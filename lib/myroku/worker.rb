require 'myroku/resque'
require 'capistrano/cli'

module Myroku
module Job

class ProxyUpdate
  @queue = :proxy_update
  def self.perform
    ARGV.replace(%w[proxy:update])
    Capistrano::CLI.execute
  end
end

end
end
