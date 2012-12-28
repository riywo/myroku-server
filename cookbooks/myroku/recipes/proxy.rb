#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/etc/nginx/conf.d" do
  action :delete
  not_if { File.symlink? "/etc/nginx/conf.d" }
end

link "/etc/nginx/conf.d" do
  to "/var/myroku/nginx/current"
end
