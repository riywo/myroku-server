#require 'sinatra/activerecord'
require 'active_record'
require 'myroku/config'
require 'gitolite'

ActiveRecord::Base.establish_connection(Myroku::Config.new.load['database'])
ActiveRecord::Migrator.up('db/migrate')

module Myroku
module Model

class Application < ActiveRecord::Base
end

class User < ActiveRecord::Base
  @@ga_repo = Gitolite::GitoliteAdmin.new(File.expand_path("../../../../gitolite-admin", __FILE__))

  def self.post(params)
    user = find_or_initialize_by_email(params[:email])
    pubkey = params[:pubkey][:tempfile]
    user.pubkey = pubkey.read
    user.save

    key = Gitolite::SSHKey.from_string(user.pubkey, user.email)
    @@ga_repo.add_key key
    @@ga_repo.save_and_apply

    user
  end
end

end
end
