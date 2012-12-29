#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

myroku_user = node['myroku']['username']
myroku_home = "#{node['user']['home_root']}/#{myroku_user}"

rbenv_ruby node['myroku']['ruby_version']
rbenv_gem "bundler" do
  ruby_version node['myroku']['ruby_version']
end

execute "rbenv local #{node['myroku']['ruby_version']}" do
  user  myroku_user
  group myroku_user
  cwd   myroku_home
  environment ({'HOME' => myroku_home})
end
