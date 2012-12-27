require 'resque'
require 'myroku/config'

Resque.redis = Myroku::Config.new.redis_url
