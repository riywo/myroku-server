require 'active_record'
require 'myroku/config'
require 'gitolite'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

module Myroku
module Model

class Application < ActiveRecord::Base
  has_one :app_server, :autosave => true, :dependent => :destroy
  has_one :db_server,  :autosave => true, :dependent => :destroy
  has_many :environments

  def initialize(attributes = nil, options = {})
    name = attributes[:name]
    subdomain = attributes[:subdomain] || name
    super({:name => name, :subdomain => subdomain}, options)

    build_app_server(:name => name, :host => attributes[:app_host], :port => attributes[:app_port])
    build_db_server(:name => name, :host => attributes[:db_host], :redis_db => attributes[:redis_db])
  end

  def save
    super
    if name != 'myroku-server'
      update_ga_repo
      create_cap_file
    end
  end

  def update_ga_repo
    ga_repo.update
    repo = Gitolite::Config::Repo.new(name)
    repo.add_permission("RW+", "", "@all")
    ga_repo.config.add_repo(repo)
    ga_repo.save_and_apply
  end

  def create_cap_file
    file = File.expand_path("../../../cap/app/#{name}.rb", __FILE__)
    system("touch #{file}")
  end

  def ga_repo
    @ga_repo ||= Gitolite::GitoliteAdmin.new('/var/myroku/gitolite-admin')
    @ga_repo
  end

  def config
    @config ||= Myroku::Config.new
    @config
  end

  def fqdn
    subdomain + '.' + config.common['app_domain']
  end

  def url
    "http://#{fqdn}"
  end

  def git_url
    admin_domain = config.common['admin_domain']
    "git@#{admin_domain}:#{name}"
  end

  def git_url_internal
    "git@localhost:#{name}"
  end

  def backend_url
    "http://#{app_server.host}:#{app_server.port}"
  end

end

class AppServer < ActiveRecord::Base
  belongs_to :applications

  def initialize(attributes = nil, options = {})
    host = attributes[:host] || Myroku::Config.new.servers['app'].sample
    port = attributes[:port] || free_port(host)
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
    host = attributes[:host] || Myroku::Config.new.servers['db'].sample
    mysql_db = escape_mysql_db(attributes[:name])
    mongo_db = escape_mongo_db(attributes[:name])
    redis_db = attributes[:redis_db].nil? ? define_redis_db(attributes[:name]) : attributes[:redis_db]

    super({:host => host, :mysql_db => mysql_db, :mongo_db => mongo_db, :redis_db => redis_db}, options)
  end

  def escape_mysql_db(name)
    "myroku_#{name}"
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

class Environment < ActiveRecord::Base
  belongs_to :applications
end

class User < ActiveRecord::Base
  def self.post(params)
    user = find_or_initialize_by_email(params[:email])
    pubkey = params[:pubkey][:tempfile]
    user.pubkey = pubkey.read.chomp
    user.save
    user
  end
end

end
end
