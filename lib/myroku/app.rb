require 'sinatra/base'
require 'myroku/config'
require 'myroku/model'
require 'myroku/resque'

module Myroku

class App < Sinatra::Base
  configure do
    config = Myroku::Config.new
    set :config, config
  end

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

  post '/application/:name' do
    app = Model::Application.find_by_name(params[:name])
    Resque.enqueue(Myroku::Job::AppDeploy, app.name)
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
