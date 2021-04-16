# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require 'rack-flash'
require_relative '../../logic/authentication'

Warden::Strategies.add(:password) do
  def flash
    env['x-rack.flash']
  end

  def valid?
    params['email'] && params['password']
  end

  def authenticate!
    email = params['email']

    begin
      user = Authentication.authenticate_user(email, params['password'])

      return success!(user) if user.allowed_to_login?

      fail!('User is not authorized to login')
    rescue Authentication::AuthenticationFailedError => e
      fail!(e.message)
    end
  end
end

# Authentication Controller
class Web < Sinatra::Base
  use Rack::Flash, accessorize: [:error, :success]

  use Warden::Manager do |manager|
    manager.serialize_into_session do |user|
      JSON.generate(user)
    end
    manager.serialize_from_session do |json_string|
      Authentication::SessionUser.new(JSON.parse(json_string))
    end

    manager.default_strategies :password
    manager.scope_defaults :default, strategies: [:password], action: '/unauthenticated'
    manager.failure_app = self
  end

  get('/login') { slim :login }

  post '/login' do
    env['warden'].authenticate!

    if session[:return_to].nil? || session[:return_to] == '/login'
      redirect '/pages/'
    else
      redirect session[:return_to]
    end
  end

  post '/unauthenticated' do
    _unauthenticated
  end

  get '/unauthenticated' do
    _unauthenticated
  end

  def _unauthenticated
    attempted_path = env['warden.options'][:attempted_path]
    if attempted_path.match? '/rest/.*'
      status 401
      return
    end

    session[:return_to] = attempted_path
    flash[:error] = env['warden'].message
    redirect '/login'
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout

    slim :login
  end
end
