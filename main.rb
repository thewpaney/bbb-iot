require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
#require 'mongoid'
require 'beaglebone'

include Beaglebone

# Mongoid.load!("mongoid.yml")

class BBBIOT < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  valid_actions = ["index", "gpio"]

  get '/' do
    redirect '/gpio'
  end

  get '/index' do
    redirect '/gpio'
  end

  get '/gpio' do
    @pins = (11..31).collect {|e| "P9_#{e}"} + (41..42).collect {|e| "P9_#{e}"} + (3..46).collect {|e| "P8_#{e}"}
    # @pins = ["P9_12"] # testing
    erb :gpio
  end

  post '/gpio' do
    puts params.inspect
    # Needs to have format: P[8|9]_[1-46]
#    valid = /P[8|9]_([0-9][0-9]?)\z/.match(params[:pin])
 #   return "bad pin" if valid.nil? or valid[1].to_i > 46 or valid[1].to_i < 0
  #  puts valid.inspect
    # pin = valid[0].to_sym
    pin = params[:pin].to_sym
    case params[:action]
    when "read"
      return GPIO.digital_read(pin).to_s
    when "set"
      return "no value specified" unless params[:value]
      GPIO.digital_write(pin, params[:value])
      return params[:value].to_s
    when "init"
      GPIO.pin_mode(pin, params[:mode].to_sym, params[:pullmode] ? params[:pullmode].to_sym : nil, params[:slewrate] ? params[:slewrate].to_sym : nil)
      return params[:mode].to_s
    when "disable"
      Beaglebone::disable_pin(pin)
      return "Disabled"
    end
  end
  
  get '/*' do |action|
    if valid_actions.include?(action)
      status 200
      erb action.to_sym
    else
      status 404
      erb :err_404
    end
  end
  
  # Allow running web server via `ruby main.rb`
  run! if app_file == $0
    
end
