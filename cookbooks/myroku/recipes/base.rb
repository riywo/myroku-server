#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "ubuntu","debian"
  include_recipe "apt"
end
include_recipe "build-essential"

package "vim" do
  action :install
end
package "strace" do
  action :install
end
package "dstat" do
  action :install
end

include_recipe 'myroku::user'
