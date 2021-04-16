# frozen_string_literal: true

require 'bundler'
require 'rack/protection'
require 'rubygems'
require 'sinatra'

Bundler.require

register Config
Config.setup do |config|
  config.use_env = true
  config.env_prefix = 'CFG'
  config.env_separator = '__'
  config.env_converter = :downcase
  config.env_parse_values = true
end

use Rack::Session::Pool, key: 'r.session',
                         expire_after: 86_400, # 1 day
                         secret: Settings.session.secret

use Rack::Protection

require './app/dashboard'
run AdminDashboard
