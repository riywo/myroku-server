$: << File.expand_path(File.dirname(__FILE__) + "/lib")
#require 'bundler'
#Bundler.require
require 'myroku/model'
require 'myroku/config'
require 'myroku/resque'

namespace :db do
  desc "migrate your database"
  task :migrate do
    ActiveRecord::Migrator.migrate(
      'db/migrate',
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end
end

desc "Create admin application"
task "admin:create" do
  admin_host = Myroku::Config.new.servers['admin']
  admin_port = Myroku::Config.new.common['admin_port']
  unless Myroku::Model::Application.exists?(:name => 'myroku-server')
    Myroku::Model::Application.create(
      :name      => 'myroku-server',
      :subdomain => 'www',
      :app_host  => admin_host,
      :app_port  => admin_port,
      :db_host   => admin_host,
      :redis_db  => 0
    )
    File.write(File.expand_path('../triggers/.envrc', __FILE__), <<-EOF)
export MYROKU_ADMIN_URL=http://#{admin_host}:#{admin_port}
    EOF
    Resque.enqueue(Myroku::Job::ProxyDeploy)
  end
end

task "cap:create" do
  apps = Myroku::Model::Application.where("name != 'myroku-server'")
  apps.each do |app|
    File.write("./cap/app/#{app.name}.rb", "")
  end
end

require 'resque/tasks'
task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
