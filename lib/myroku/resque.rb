require 'resque'
require 'myroku/config'
require 'capistrano/cli'
require 'gitolite'

Resque.redis = ENV['REDIS_URL']

module Myroku
module Job

class UserCreate
  @queue = :user_create
  @@ga_repo = Gitolite::GitoliteAdmin.new('/var/myroku/gitolite-admin')
  def self.perform(pubkey, email)
    @@ga_repo.update
    key = Gitolite::SSHKey.from_string(pubkey, email)
    @@ga_repo.add_key key
    @@ga_repo.save_and_apply
  end
end

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
