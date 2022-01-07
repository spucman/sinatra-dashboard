# frozen_string_literal: true

require 'sinatra/base'
require 'rack/contrib'
require 'json'

# Entry Point for all rest requests
class Rest < Sinatra::Base
  disable :show_exceptions

  use Rack::JSONBodyParser

  configure do
    set :views, 'app/web/views'
    set :public_dir, 'app/web/public'
    Slim::Engine.set_options attr_list_delims: { '(' => ')', '[' => ']' }
    Slim::Include.set_options include_dirs: [File.expand_path('../../views/partial', __dir__)]
  end

  before '/rest/*' do
    env['warden'].authenticate!
    content_type :json
  end

  set(:auth) do |*features|
    condition do
      env['warden'].authenticate!

      user = env['warden'].user
      redirect _create_permission_msg, 403 unless features.any? { |feature| user.feature? feature }
    end
  end

  error 500 do
    _create_error('An unexpected error occured')
  end

  error 401 do
    _create_error('Please sign in')
  end

  def _create_error(msg)
    JSON.generate({ error: { message: msg } })
  end

  def _create_permission_msg
    _create_error("You don't have the permissions to access this endpoint.")
  end

  def _create_disabled_feature_msg
    _create_error('This feature is disabled.')
  end
end
