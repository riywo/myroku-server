$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'myroku/config'

servers = Myroku::Config.new.servers
role :app,   *servers['app']
role :proxy, *servers['proxy']
role :db,    *servers['db']

load './lib/myroku/task'
