$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'myroku/config'

servers = Myroku::Config.new.load['servers']
role :app,   *servers['app']
role :proxy, *servers['proxy']
