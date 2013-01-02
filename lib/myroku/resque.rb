require 'resque'
require 'myroku/config'
require 'capistrano/cli'

Resque.redis = Myroku::Config.new.redis_url

module Myroku
module Job

class ProxyDeploy
  @queue = :proxy_deploy
  def self.perform
    ARGV.replace(%w[proxy deploy])
    Capistrano::CLI.execute
  end
end

class AdminDeploy
  @queue = :admin_deploy
  def self.perform
    ARGV.replace(%w[admin deploy])
    Capistrano::CLI.execute
  end
end

class AppDeploy
  @queue = :app_deploy
  def self.perform(app)
    ARGV.replace(%W[app:#{app} deploy])
    Capistrano::CLI.execute
  end
end

end
end
