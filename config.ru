$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'bundler'
Bundler.require

require 'myroku/app'
run Myroku::App
