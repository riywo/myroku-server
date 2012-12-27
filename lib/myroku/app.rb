require 'sinatra/base'
require 'myroku/config'
require 'myroku/model'

module Myroku

class App < Sinatra::Base
  get '/' do
    {
      :user => Model::User.all,
      :app  => Model::Application.all,
      :app_servers => Model::AppServer.all,
      :db_servers => Model::DbServer.all,
    }.to_json
  end

  post '/application' do
    Model::Application.create(params).to_json
  end

  post '/user' do
    Model::User.post(params).to_json
  end

end

end
