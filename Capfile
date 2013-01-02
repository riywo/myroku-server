$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'myroku/config'
set :servers, Myroku::Config.new.servers

require 'railsless-deploy'
load 'lib/myroku/task'

set :config_root, 'cap'
require 'capistrano/multiconfig'
