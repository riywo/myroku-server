#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'myroku::ruby'
myroku_user = node['myroku']['username']

directory "/var/myroku/app" do
  owner myroku_user
  group myroku_user
end

directory "/var/myroku/service" do
  owner myroku_user
  group myroku_user
end

directory "/var/log/myroku/app" do
  owner myroku_user
  group myroku_user
end

include_recipe 'daemontools'
