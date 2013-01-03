#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

link "/etc/nginx/sites-enabled/myroku" do
  to "/etc/nginx/sites-available/myroku"
end
