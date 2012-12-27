#require 'sinatra/activerecord'
require 'active_record'
require 'myroku/config'
require 'gitolite'

ActiveRecord::Base.establish_connection(Myroku::Config.new.load['database'])
ActiveRecord::Migrator.up('db/migrate')

module Myroku
module Model

class Application < ActiveRecord::Base
  has_one :app_server, :autosave => true
  has_one :db_server,  :autosave => true

  def initialize(attributes = nil, options = {})
    name = attributes[:name]
    subdomain = name
    super({:name => name, :subdomain => subdomain}, options)

    build_app_server(:name => name)
    build_db_server(:name => name)
  end
end

class AppServer < ActiveRecord::Base
  belongs_to :applications

  def initialize(attributes = nil, options = {})
    host = Myroku::Config.new.load['servers']['app'].sample
    port = free_port(host)
    super({:host => host, :port => port}, options)
  end

  def free_port(host)
    port = 10000 + rand(1000)
    while AppServer.exists?(:host => host, :port => port) do
      port = 10000 + rand(1000)
    end
    port
  end

end

class DbServer < ActiveRecord::Base
  belongs_to :applications

  def initialize(attributes = nil, options = {})
    host = Myroku::Config.new.load['servers']['db'].sample
    mysql_db = escape_mysql_db(attributes[:name])
    mongo_db = escape_mongo_db(attributes[:name])
    redis_db = define_redis_db(attributes[:name])

    super({:host => host, :mysql_db => mysql_db, :mongo_db => mongo_db, :redis_db => redis_db}, options)
  end

  def escape_mysql_db(name)
    name
  end

  def escape_mongo_db(name)
    name
  end

  def define_redis_db(name)
    db = 1 + rand(999)
    while DbServer.exists?(:redis_db => db) do
      db = 1 + rand(999)
    end
    db
  end

end

class User < ActiveRecord::Base
  @@ga_repo = Gitolite::GitoliteAdmin.new(File.expand_path("../../../../gitolite-admin", __FILE__))

  def self.post(params)
    user = find_or_initialize_by_email(params[:email])
    pubkey = params[:pubkey][:tempfile]
    user.pubkey = pubkey.read.chomp
    user.save

    key = Gitolite::SSHKey.from_string(user.pubkey, user.email)
    @@ga_repo.add_key key
    @@ga_repo.save_and_apply

    user
  end
end

end
end
