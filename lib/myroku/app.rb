require 'sinatra/base'
require 'myroku/config'
require 'myroku/model'

module Myroku

class App < Sinatra::Base
  set :myroku, Myroku::Config.new.load

  get '/' do
    {
      :user => Model::User.all,
      :app  => Model::Application.all,
      :app_servers => Model::AppServer.all,
      :db_servers => Model::DbServer.all,
    }.to_json
  end

  get '/application/:id' do
    app = Model::Application.find(params[:id])
    {
      :name    => app.name,
      :url     => app.url,
      :git => {
        :url      => app.git_url,
        :revision => app.revision,
      },
    }.to_json
  end

  post '/application' do
    app = Model::Application.create(params)
    redirect to("/application/#{app.id}")
  end

  post '/user' do
    Model::User.post(params).to_json
  end

end

end
