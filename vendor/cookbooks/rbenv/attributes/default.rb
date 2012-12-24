#
# Cookbook Name:: rbenv
# Attributes:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2011-2012, Riot Games
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:rbenv][:group_users]         = Array.new
default[:rbenv][:git_repository]      = "git://github.com/sstephenson/rbenv.git"
default[:rbenv][:git_revision]        = "master"
default[:rbenv][:install_prefix]      = "/opt"

default[:ruby_build][:git_repository] = "git://github.com/sstephenson/ruby-build.git"
default[:ruby_build][:git_revision]   = "master"
default[:ruby_build][:prefix]         = "/usr/local"
