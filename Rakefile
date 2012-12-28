$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'bundler'
Bundler.require

require 'resque/tasks'
require 'myroku/worker'

task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
