Description
===========

This cookbook provides an easy way to install CloudFuse.

More information?
http://www.rackspace.com/knowledge_center/node/1873

Requirements
============

## Cookbooks:

* build-essential
* git

## Platforms:

* Ubuntu

Attributes
==========

* `node['cloudfuse']['git_repository']` - Location of the source git repository
* `node['cloudfuse']['git_revision']` - Revision of the git repository to install
* `node['cloudfuse']['compile_flags']` - Array of flags to use in compilation process
* `node['cloudfuse']['rscf_username']` - Rackspace Cloud Files username
* `node['cloudfuse']['rscf_api_key']` - Rackspace Cloud Files API key
* `node['cloudfuse']['rscf_authurl']` - Rackspace Cloud Files authentication URL
* `node['cloudfuse']['rscf_use_snet']` - Rackspace Cloud Files use servicenet for connections
* `node['cloudfuse']['cache_timeout']` - Seconds for directory caching, default 600
* `node['cloudfuse']['fused_directory']` - Directory on which RSCF will be mounted, "fused"

Usage
=====

1) include `recipe[cloudfuse]` in a run list
2) tweak the attributes via attributes/default.rb
	--- OR ---
	override the attribute on a higher level (http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence)

References
==========

* [CloudFuse homepage] (http://redbo.github.com/cloudfuse/)
* [github] (https://github.com/redbo/cloudfuse/)
* [Rackspace knowledge center article] (http://www.rackspace.com/knowledge_center/node/1873)
* [CloudFuse blog article] (http://sandeepsidhu.wordpress.com/2011/03/07/mounting-cloud-files-using-cloudfuse-into-ubuntu-10-10-v2/)

License and Authors
===================

Author: David Joos <david.joos@gmail.com>
Copyright: 2012

Unless otherwise noted, all files are released under the MIT license,
possible exceptions will contain licensing information in them.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.