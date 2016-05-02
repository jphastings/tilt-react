require 'sinatra/base'
require 'sinatra/react'

class ExampleApp < Sinatra::Base
  register Sinatra::React

  get '/' do
    react :home_page, locals: { name: params['name'] }
  end

  get '/other' do
    react :other_page
  end
end
