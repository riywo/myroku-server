#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "user"
myroku_user = node['myroku']['app']['username']
myroku_home = "#{node['user']['home_root']}/#{myroku_user}"
user_account myroku_user
