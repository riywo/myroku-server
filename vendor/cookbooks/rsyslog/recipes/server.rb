#
# Cookbook Name:: rsyslog
# Recipe:: server
#
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "rsyslog"

node.set['rsyslog']['server'] = true
node.save unless Chef::Config[:solo]

directory ::File.dirname(node['rsyslog']['log_dir']) do
  owner node["rsyslog"]["user"]
  group node["rsyslog"]["group"]
  recursive true
  mode 0755
end

directory node['rsyslog']['log_dir'] do
  owner node['rsyslog']['user']
  group node['rsyslog']['group']
  mode 0755
end

template "/etc/rsyslog.d/35-server-per-host.conf" do
  source "35-server-per-host.conf.erb"
  backup false
  variables(
    :log_dir => node['rsyslog']['log_dir'],
    :per_host_dir => node['rsyslog']['per_host_dir']
  )
  owner node["rsyslog"]["user"]
  group node["rsyslog"]["group"]
  mode 0644
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

file "/etc/rsyslog.d/remote.conf" do
  action :delete
  backup false
  notifies :reload, "service[#{node['rsyslog']['service_name']}]"
  only_if do ::File.exists?("/etc/rsyslog.d/remote.conf") end
end
