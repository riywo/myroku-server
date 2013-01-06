$: << File.expand_path(File.dirname(__FILE__) + "/lib")
#require 'bundler'
#Bundler.require
require 'myroku/model'

namespace :db do
  desc "migrate your database"
  task :migrate do
    ActiveRecord::Migrator.migrate(
      'db/migrate',
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end
end

desc "Create application manually (name=NAME subdomain=SUBDOMAIN app_host=APP_HOST app_port=APP_PORT db_host=DB_HOST redis_db=REDIS_DB)"
task "app:create" do
  name      = ENV['name']
  subdomain = ENV['subdomain']
  app_host  = ENV['app_host']
  app_port  = ENV['app_port']
  db_host   = ENV['db_host']
  redis_db  = ENV['redis_db']
  Myroku::Model::Application.create(:name => name, :subdomain => subdomain, :app_host => app_host, :app_port => app_port, :db_host => db_host, :redis_db => redis_db)
end

require 'resque/tasks'
require 'myroku/resque'

task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
