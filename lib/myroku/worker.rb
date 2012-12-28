require 'myroku/resque'

module Myroku
module Job

class ProxyUpdate
  @queue = :proxy_update
  def self.perform
  end
end

end
end
