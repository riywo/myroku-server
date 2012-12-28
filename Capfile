$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'myroku/config'

servers = Myroku::Config.new.servers
role :app,   *servers['app']
role :proxy, *servers['proxy']
role :db,    *servers['db']

require 'railsless-deploy'
#load 'deploy'
load 'lib/myroku/task'

set :config_root, 'cap'
require 'capistrano/multiconfig'
