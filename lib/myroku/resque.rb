require 'resque'
require 'myroku/config'
require 'capistrano/cli'

Resque.redis = ENV['REDIS_URL']

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
    ARGV.replace(%w[admin deploy:setup deploy])
    Capistrano::CLI.execute
  end
end

class AppDeploy
  @queue = :app_deploy
  def self.perform(name)
    ARGV.replace(%W[app:#{name} deploy:setup deploy])
    Capistrano::CLI.execute
  end
end

end
end
