require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'mongoid'
require 'haml'
require 'beaglebone'

# Mongoid.load!("mongoid.yml")

class BBBIOT < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  valid_actions = ["index", "gpio"]

  get '/' do
    haml :index
  end

  get '/*' do |action|
    if valid_actions.include?(action)
      status 200
      haml action.to_sym
    else
      status 404
      haml :err_404
    end
  end
  
  # Allow running web server via `ruby main.rb`
  run! if app_file == $0
    
end
