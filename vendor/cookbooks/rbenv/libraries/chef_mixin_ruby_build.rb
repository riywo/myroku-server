#
# Cookbook Name:: rbenv
# Library:: mixin_ruby_build
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

require 'chef/mixin/shell_out'

class Chef
  module Mixin
    module RubyBuild
      def ruby_build_binary_path
        "#{node[:ruby_build][:prefix]}/bin/ruby-build"
      end

      def ruby_build_installed_verison
        out = shell_out("#{ruby_build_binary_path} --version", :env => nil)
        out.stdout.chomp
      end
    end
  end
end
