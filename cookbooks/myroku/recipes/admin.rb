#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'myroku::ruby'

myroku_user = node['myroku']['app']['username']
myroku_home = "#{node['user']['home_root']}/#{myroku_user}"

node.set['gitolite2']['public_key_path'] = "#{myroku_home}/.ssh/id_dsa.pub"
include_recipe "gitolite2"

execute "add localhost to known_hosts" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  command "ssh-keyscan localhost >> #{myroku_home}/.ssh/known_hosts"
  not_if "grep -q \"`ssh-keyscan localhost`\" #{myroku_home}/.ssh/known_hosts"
end

execute "gitconfig user" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git config --global user.name #{myroku_user}"
  not_if "git config --global --get user.name"
end

execute "gitconfig email" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git config --global user.email #{myroku_user}@localhost"
  not_if "git config --global --get user.email"
end

execute "git clone gitolite-admin" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git clone git@localhost:gitolite-admin"
  not_if {File.exists? "#{myroku_home}/gitolite-admin"}
end

