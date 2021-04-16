# frozen_string_literal: true

require 'sinatra/base'
require 'sprockets'
require 'uglifier'

# Handles all assets (and combines and shrinks them)
class Web < Sinatra::Base
  configure do
    set :environment, Sprockets::Environment.new
    set :assets_prefix, '/assets'

    # append assets paths
    environment.append_path 'app/web/assets/stylesheets'
    environment.append_path 'app/web/assets/javascripts'
    environment.append_path 'app/web/assets/images'

    # compress assets
    environment.js_compressor = :uglify
  end

  # get assets
  get '/assets/*' do
    env['PATH_INFO'].sub!('/assets', '')
    settings.environment.call(env)
  end
end
