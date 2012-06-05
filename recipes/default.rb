#
# Cookbook Name:: cloudfuse
# Recipe:: default
#
# Copyright 2012, David Joos
#

#http://sandeepsidhu.wordpress.com/2011/03/07/mounting-cloud-files-using-cloudfuse-into-ubuntu-10-10-v2/
#case node[:platform]
#	when "ubuntu", "debian"
#	  include_recipe "newrelic::debian"
#	when "redhat", "centos", "fedora"
#	  include_recipe "newrelic::redhat"
#end
#
#directory "/var/run/newrelic" do
#  owner "newrelic"
#  group "newrelic"
#end
#
#template "/etc/newrelic/nrsysmond.cfg" do
#  source "nrsysmond.cfg.erb"
#  owner "root"
#  group "newrelic"
#  mode "640"
#  variables( :license_key => node[:newrelic][:license_key],
#             :hostname => node[:fqdn] )
#  notifies( :restart, "service[newrelic-sysmond]" ) if node[:newrelic][:enabled]
#end
#
#service "newrelic-sysmond" do
#  supports :status => true, :restart => true, :reload => true
#  if node[:newrelic][:enabled]
#    action [ :enable, :start ]
#  else
#    action [ :disable, :stop ]
#  end
#end

########
#INSTALL
########

include_recipe "build-essential"
include_recipe "git"

pkgs = [libcurl4-openssl-dev, libxml2, libxml2-dev, libfuse-dev]

pkgs.each do |pkg|
	package pkg do
  		action :upgrade
	end
end

git "#{Chef::Config[:file_cache_path]}/cloudfuse" do
	repository node[:cloudfuse][:git_repository]
	reference node[:cloudfuse][:git_revision]
	action :sync
	notifies :run, "bash[compile_cloudfuse]"
end

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
		./configure
		make clean && make && make install
	EOH
end

######
#MOUNT
######

#create configuration file
#.cloudfuse
#REQUIRED
#username=[username]
#api_key=[api key]
#authurl=[auth URL]
#OPTIONAL
#use_snet=[True to use snet for connections]
#cache_timeout=[seconds for directory caching, default 600]

mkdir cloudfiles
#cloudfuse /cloudfiles

#If you are not the root of the system, then you username will need to be part of “fuse” group. This can probably be accomplished with:
#sudo usermod -a -G fuse [username]