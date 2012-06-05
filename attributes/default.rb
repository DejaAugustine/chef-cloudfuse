#
# Cookbook Name:: cloudfuse
# Recipe:: default
#
# Copyright 2012, David Joos
#

default[:cloudfuse][:git_repository] = "git://github.com/redbo/cloudfuse.git"
default[:cloudfuse][:git_revision] = "HEAD"
default[:cloudfuse][:compile_flags] = []
default[:cloudfuse][:rscf_username] = "usernameS"
default[:cloudfuse][:rscf_api_key] = "api_keyS"
#US RSCF https://auth.api.rackspacecloud.com/v1.0 (default)
#UK RSCF https://lon.auth.api.rackspacecloud.com/v1.0
default[:cloudfuse][:rscf_authurl] = "https://auth.api.rackspacecloud.com/v1.0"
default[:cloudfuse][:rscf_use_snet] = nil
default[:cloudfuse][:cache_timeout] = nil
default[:cloudfuse][:fused_directory] = nil