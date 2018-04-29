require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
#require 'mongoid'
require 'haml'
require 'beaglebone'

include Beaglebone

# Mongoid.load!("mongoid.yml")

class BBBIOT < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  valid_actions = ["index", "gpio"]

  get '/' do
    haml :index
  end

  post '/gpio' do
    puts params.inspect
    # Needs to have format: P[8|9]_[1-46]
#    valid = /P[8|9]_([0-9][0-9]?)\z/.match(params[:pin])
 #   return "bad pin" if valid.nil? or valid[1].to_i > 46 or valid[1].to_i < 0
  #  puts valid.inspect
    # pin = valid[0].to_sym
    pin = "P9_12".to_sym
    case params[:action]
    when "read"
      return GPIO.digital_read(pin)
    when "set"
      return "no value specified" unless params[:value]
      GPIO.digital_write(pin, params[:value])
      return "wrote #{params[:value]}"
    when "init"
      GPIO.pin_mode(pin, params[:mode].to_sym, params[:pullmode] ? params[:pullmode].to_sym : nil, params[:slewrate] ? params[:slewrate].to_sym : nil)
      return "mode: #{params[:mode]}"
    when "disable"
      Beaglebone::disable_pin(pin)
      return "disabled"
    end
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
