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

  before do
    puts params.inspect
  end

  valid_actions = ["index", "gpio"]

  get '/' do
    redirect '/gpio'
  end

  get '/index' do
    redirect '/gpio'
  end

  get '/gpio' do
    @pins = (11..31).collect {|e| "P9_#{e}"} + (41..42).collect {|e| "P9_#{e}"} + (3..46).collect {|e| "P8_#{e}"}
    erb :gpio
  end

  get '/pwm' do
    @pins = [14,16,21,22].collect {|e| "P9_#{e}"} + [13,19].collect {|e| "P8_#{e}"}
    erb :pwm
  end

  post '/gpio' do
    # Needs to have format: P[8|9]_[1-46]
    valid = /P[8|9]_([0-9][0-9]?)\z/.match(params[:pin])
    return "pin not GPIO enabled" if valid.nil? or valid[1].to_i > 46 or valid[1].to_i < 0
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
    else
      return "Bad action"
    end
  end

  post '/pwm' do
    valid = /P([8|9])_([0-9][0-9]?)\z/.match(params[:pin])
    if valid.nil? or (valid[1] == "8" and not ([13,19].include? valid[2])) or (valid[1] == "9" and not ([14,16,21,22].include? valid[2]))
      return "pin not PWM enabled"
    end
    pin = params[:pin].to_sym
    case params[:action]
    when "disable"
      BeagleBone::disable_pin(pin)
      return "Disabled"
    when "start"
      PWM.start(pin, params[:f].to_i, params[:dc].to_i, params[:p] ? params[:p].to_sym : :NORMAL)
    when "set"
      params.each do |k,v|
        case k
        when "f"
          PWM.set_frequency(pin, v.to_i)
        when "dc"
          PWM.set_duty_cycle(pin, v.to_i)
        when "t_ns"
          PWM.set_period_ns(pin, v.to_i)
        when "dc_ns"
          PWM.set_duty_cycle_ns(pin, v.to_i)
        when "p"
          PWM.set_polarity(pin, v.to_sym)
        end
      end
    else
      return "Bad action"
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
