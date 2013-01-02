$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'myroku/config'
set :servers, Myroku::Config.new.servers
set :ssh_options, { :keys => ['/home/myroku/.ssh/id_rsa'], :user_known_hosts_file => ['/home/myroku/.ssh/known_hosts'] }

require 'railsless-deploy'
load 'lib/myroku/task'

set :config_root, 'cap'
require 'capistrano/multiconfig'
