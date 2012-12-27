require 'sinatra/base'
require 'myroku/config'
require 'myroku/model'

module Myroku

class App < Sinatra::Base
  get '/' do
    Model::User.all.to_json
  end

  post '/user' do
    Model::User.post(params).to_json
  end

end

end
