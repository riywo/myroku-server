#
# Cookbook Name:: gitolit2
# Recipe:: default
#
# Copyright 2010, RailsAnt, Inc.
# Copyright 2012, Gerald L. Hevener Jr., M.S.
# Copyright 2012, Eric G. Wolfe
# Copyright 2012, Ryosuke IWANAGA
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
#
if node['gitolite2']['public_key'].nil? and node['gitolite2']['public_key_path'].nil?
  Chef::Log.fatal("You must pass your public key content by gitolite/public_key or public_key_path")
  raise Chef::Exceptions
end
if !node['gitolite2']['public_key'].nil? and !node['gitolite2']['public_key_path'].nil?
  Chef::Log.fatal("either gitolite/public_key or public_key_path")
  raise Chef::Exceptions
end

%w{ git perl }.each do |cb_include|
  include_recipe cb_include
end

# Install missing perl modules
case node['platform']
when "redhat","centos","scientific","amazon","oracle","fedora"
  package "perl-Time-HiRes"
end

# Add git user
# Password isn't set correctly in original recipe, and really no reason to set one.
user node['gitolite2']['user'] do
  comment "Git User"
  home node['gitolite2']['home']
  shell "/bin/bash"
  supports :manage_home => true
end

directory node['gitolite2']['home'] do
  owner node['gitolite2']['user']
  group node['gitolite2']['group']
  mode 0750
end

directory "#{node['gitolite2']['home']}/bin" do
  owner node['gitolite2']['user']
  group node['gitolite2']['group']
  mode 0775
end

# Create a $HOME/.ssh folder
directory "#{node['gitolite2']['home']}/.ssh" do
  owner node['gitolite2']['user']
  group node['gitolite2']['group']
  mode 0700
end

# Gitolite.rc template
template "#{node['gitolite2']['home']}/.gitolite.rc" do
  source "gitolite.rc.erb"
  owner node['gitolite2']['user']
  group node['gitolite2']['group']
  mode 0644
  variables(
    :umask => node['gitolite2']['umask']
  )
end

# Clone gitolite repo from github
git node['gitolite2']['gitolite_home'] do
  repository node['gitolite2']['gitolite_url']
  reference node['gitolite2']['gitolite_reference']
  user node['gitolite2']['user']
  group node['gitolite2']['group']
  action :checkout
end

# Gitolite application install script
execute "gitolite-install" do
  user node['gitolite2']['user']
  group node['gitolite2']['group']
  cwd node['gitolite2']['home']
  command "#{node['gitolite2']['gitolite_home']}/install -ln #{node['gitolite2']['home']}/bin"
  creates "#{node['gitolite2']['home']}/bin/gitolite"
end

# Create public key
key_file = "#{node['gitolite2']['home']}/.ssh/admin.pub"
unless node['gitolite2']['public_key'].nil?
  file key_file do
    owner node['gitolite2']['user']
    group node['gitolite2']['group']
    mode 0644
    content node['gitolite2']['public_key']
    action :create
  end
else
  execute "cp #{node['gitolite2']['public_key_path']} #{key_file}"
  file key_file do
    owner node['gitolite2']['user']
    group node['gitolite2']['group']
    mode 0644
    action :create
  end
end

# Gitolite public key setup script
execute "gitolite setup" do
  user node['gitolite2']['user']
  group node['gitolite2']['group']
  cwd node['gitolite2']['home']
  environment ({'HOME' => node['gitolite2']['home']})
  command "#{node['gitolite2']['home']}/bin/gitolite setup -pk #{key_file}"
  not_if "grep -q \"`cat #{key_file}`\" #{node['gitolite2']['home']}/.ssh/authorized_keys"
end

