#
# Cookbook Name:: cloudfuse
# Recipe:: default
#
# Copyright 2012, David Joos
#

#include required recipes
include_recipe "build-essential"
include_recipe "git"

#install required packages
case node[:platform]
	when "ubuntu", "debian"
		pkgs = ["libcurl3-dev", "libxml2", "libxml2-dev", "libfuse-dev"]
	when "redhat", "centos", "fedora"
		pkgs = ["openssl", "openssl-devel", "curl", "curl-devel", "libxml2", "libxml2-devel", "fuse", "fuse-devel"]
end

pkgs.each do |pkg|
	package pkg do
  		action :upgrade
	end
end

#get source
git "#{Chef::Config[:file_cache_path]}/cloudfuse" do
	repository node[:cloudfuse][:git_repository]
	reference node[:cloudfuse][:git_revision]
	action :sync
	notifies :run, "bash[compile_cloudfuse]"
end

#install
#Write the flags used to compile the application to disk. If the flags
#do not match those that are in the compiled_flags attribute - we recompile
template "#{Chef::Config[:file_cache_path]}/cloudfuse-compiled_with_flags" do
	source "compiled_with_flags.erb"
	owner "root"
	group "root"
	mode 0600
	variables(
		:compile_flags => node[:cloudfuse][:compile_flags]
	)
	notifies :run, "bash[compile_cloudfuse]"
end

bash "compile_cloudfuse" do
	cwd "#{Chef::Config[:file_cache_path]}/cloudfuse"
	code <<-EOH
		./configure #{node[:cloudfuse][:compile_flags].join(' ')}
		make clean && make && make install
	EOH
end
		
#create configuration file
template "#{ENV["HOME"]}/.cloudfuse" do
	source "cloudfuse.erb"
	owner "root"
	group "root"
	mode 0640
	variables(
		:username => node[:cloudfuse][:rscf_username],
		:api_key => node[:cloudfuse][:rscf_api_key],
		:authurl => node[:cloudfuse][:rscf_authurl],
		:use_snet => node[:cloudfuse][:rscf_use_snet],
		:cache_timeout => node[:cloudfuse][:cache_timeout]
	)
end

#mount
unless node[:cloudfuse][:fused_directory].nil?
	directory "#{node[:cloudfuse][:fused_directory]}" do
		owner "root"
		group "root"
		notifies :run, "execute[cloudfuse-fuse]"
	end

	execute "cloudfuse-fuse" do
		command "cloudfuse #{node[:cloudfuse][:fused_directory]} #{node[:cloudfuse][:command_flags]}"
		action :nothing
	end
end