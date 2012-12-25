require 'sinatra/base'

module Myroku

class App < Sinatra::Base
  get '/' do
    'hello world'
  end
end

end
