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
myroku_home = "#{node['user']['home_root']}/#{myroku_user}"

node.set['gitolite2']['public_key_path'] = "#{myroku_home}/.ssh/id_rsa.pub"
include_recipe "gitolite2"

servers = (node['myroku']['servers']['app'] + node['myroku']['servers']['proxy'] + node['myroku']['servers']['db']).uniq
servers.each do |server|
  execute "add #{server} to known_hosts" do
    user myroku_user
    group myroku_user
    cwd myroku_home
    command "ssh-keyscan #{server} >> #{myroku_home}/.ssh/known_hosts"
    not_if "grep -q \"`ssh-keyscan #{server}`\" #{myroku_home}/.ssh/known_hosts"
  end
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
  command "git clone git@localhost:gitolite-admin /var/myroku/gitolite-admin"
  not_if {File.exists? "/var/myroku/gitolite-admin"}
end

directory "/var/log/myroku" do
  owner myroku_user
  group myroku_user
end
