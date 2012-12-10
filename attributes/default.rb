#
# Cookbook Name:: cloudfuse
# Recipe:: default
#
# Copyright 2012, David Joos
#

default[:cloudfuse][:git_repository] = "git://github.com/redbo/cloudfuse.git"
default[:cloudfuse][:git_revision] = "HEAD"
default[:cloudfuse][:prefix] = "/usr/local/bin"
default[:cloudfuse][:compile_flags] = []
default[:cloudfuse][:mountpoint] = nil
default[:cloudfuse][:command_flags] = nil
default[:cloudfuse][:mount_user] = "root"
default[:cloudfuse][:mount_group] = "root"