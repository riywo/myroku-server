#
# Cookbook Name:: daemontools
# Attributes:: default
#
# Copyright 2010, Opscode, Inc
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

default['daemontools']['bin_dir'] = "/usr/local/bin"
default['daemontools']['service_dir'] = "/etc/service"
default['daemontools']['install_method'] = "source"

case node['platform']
when "ubuntu"
  if node['platform_version'].to_f >= 9.04
    default['daemontools']['bin_dir'] = "/usr/bin"
    default['daemontools']['service_dir'] = "/etc/service"
    default['daemontools']['install_method'] = "package"
  else
    default['daemontools']['bin_dir'] = "/usr/local/bin"
    default['daemontools']['service_dir'] = "/etc/service"
    default['daemontools']['install_method'] = "source"
  end
when "debian"
  if node['platform_version'].to_f >= 5.0
    default['daemontools']['bin_dir'] = "/usr/bin"
    default['daemontools']['service_dir'] = "/etc/service"
    default['daemontools']['install_method'] = "package"
  else
    default['daemontools']['bin_dir'] = "/usr/local/bin"
    default['daemontools']['service_dir'] = "/etc/service"
    default['daemontools']['install_method'] = "source"
  end
when "arch"
  default['daemontools']['bin_dir'] = "/usr/sbin"
  default['daemontools']['service_dir'] = "/etc/service"
  default['daemontools']['install_method'] = "aur"
else
  default['daemontools']['bin_dir'] = "/usr/local/bin"
  default['daemontools']['service_dir'] = "/etc/service"
  default['daemontools']['install_method'] = "source"
end
