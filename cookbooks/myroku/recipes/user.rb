#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "user"
myroku_user = node['myroku']['username']
myroku_home = "#{node['user']['home_root']}/#{myroku_user}"

user_account myroku_user do
  ssh_keys   node['myroku']['ssh']['public_key']
  ssh_keygen false
end

file "#{myroku_home}/.ssh/id_rsa" do
  owner myroku_user
  group myroku_user
  mode  0600
  content node['myroku']['ssh']['private_key']
end

file "#{myroku_home}/.ssh/id_rsa.pub" do
  owner myroku_user
  group myroku_user
  mode  0644
  content node['myroku']['ssh']['public_key']
end

include_recipe "sudo"
group "sudo" do
  members myroku_user
end

directory "/var/myroku" do
  owner myroku_user
  group myroku_user
end

directory "/var/myroku/bin" do
  owner myroku_user
  group myroku_user
end

directory "/var/log/myroku" do
  owner myroku_user
  group myroku_user
end
