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

desc "Create application manually (name=NAME subdomain=SUBDOMAIN app_host=APP_HOST app_port=APP_PORT db_host=DB_HOST)"
task "app:create" do
  name      = ENV['name']
  subdomain = ENV['subdomain']
  app_host  = ENV['app_host']
  app_port  = ENV['app_port']
  db_host   = ENV['db_host']
  Myroku::Model::Application.create(:name => name, :subdomain => subdomain, :app_host => app_host, :app_port => app_port, :db_host => db_host)
end

=begin
desc "Create exported env"
task "env:create" do
  template = ERB.new <<-EOF
#!/usr/bin/env perl
use strict;
use warnings;

for (keys %ENV) {
  next if /^LLENV/;
  delete $ENV{$_};
}
<% ENV.each { |k,v| %>
$ENV{<%= k %>} = '<%= v %>';<% } %>

exec(@ARGV);
  EOF
  File.write ".env_exported", template.result(binding)
end
=end

require 'resque/tasks'
require 'myroku/resque'

task "resque:setup" do
  ENV['QUEUE'] = '*'
  ENV['TERM_CHILD'] = "1"
end
