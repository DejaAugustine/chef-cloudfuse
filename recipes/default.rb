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
pkgs = []

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
	notifies :run, "bash[cloudfuse-compile]"
end

#compile
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
	notifies :run, "bash[cloudfuse-compile]"
end

bash "cloudfuse-compile" do
	cwd "#{Chef::Config[:file_cache_path]}/cloudfuse"
	code <<-EOH
		./configure #{node[:cloudfuse][:compile_flags].join(' ')}
		make clean && make && make install
	EOH
end

#set up mountpoint (directory)
unless node[:cloudfuse][:mountpoint].nil?
	unless File.exist?("#{node[:cloudfuse][:mountpoint]}")
		directory "cloudfuse-create-mountpoint" do
			path "#{node[:cloudfuse][:mountpoint]}"
			owner "root"
			group "root"
			action :create
		end
	end
end

#cloudfuse init script
template "/etc/init.d/cloudfuse" do
	source "cloudfuse.erb"
	owner "root"
	group "root"
	mode 0755
	variables(
		:prefix => node[:cloudfuse][:prefix],
		:mountpoint => node[:cloudfuse][:mountpoint],
		:command_flags => node[:cloudfuse][:command_flags]
	)
end

service "cloudfuse" do
	start_command "/etc/init.d/cloudfuse start"
	stop_command "/etc/init.d/cloudfuse stop"
	restart_command "/etc/init.d/cloudfuse stop"
	status_command "/etc/init.d/cloudfuse status"
	supports [:start, :stop, :restart, :status]
	#starts the service if it's not running and enables it to start at system boot time
	action [:enable, :start]
end