# frozen_string_literal: true

require 'sinatra/base'
require 'slim/include'
require 'rack/protection'
require 'json'
require 'date'
require_relative '../../logic/user_profile'
require_relative '../../logic/batch_run'
require_relative '../../logic/feature'

# Entry Point for all Pages
class Web < Sinatra::Base
  configure do
    set :views, 'app/web/views'
    set :public_dir, 'app/web/public'
    Slim::Engine.set_options attr_list_delims: { '(' => ')', '[' => ']' }
    Slim::Include.set_options include_dirs: [File.expand_path('../views/partial', __dir__)]
  end

  before '/pages/*' do
    env['warden'].authenticate!
    @user_features = env['warden'].user.features
  end

  set(:auth) do |*features|
    condition do
      env['warden'].authenticate!

      user = env['warden'].user
      redirect '/', 303 unless features.any? { |feature| user.feature? feature }
    end
  end

  get('/') { redirect '/pages/', 303 }

  get('/pages/') { slim :index }

  get '/pages/profile/:id', auth: Feature::DASHBOARD_UP do |id|
    token = env['warden'].user.token
    result = UserProfile.search_for_user_detail(token, id)

    @feature_flags = Settings.feature
    @user = if result.size == 1
              result[0].to_json
            else
              {}.to_json
            end
    slim :user
  end

  get '/pages/profile', auth: Feature::DASHBOARD_UP do
    @user_list = [].to_json
    slim :user_list
  end

  post '/pages/profile', auth: Feature::DASHBOARD_UP do
    search_string = params[:search]
    token = env['warden'].user.token
    result = UserProfile.search_for_users(token, search_string)

    if result.size > 1
      @user_list = result.to_json
      return slim :user_list
    elsif result.size == 1
      @feature_flags = Settings.feature
      @user = result[0].to_json
    else
      @feature_flags = Settings.feature
      @user = {}.to_json
    end

    slim :user
  end

  get '/pages/report/weekly' do
    slim :report_weekly
  end

  get '/pages/report/preview', auth: Feature::DASHBOARD_REPORT_PREVIEW do
    user = env['warden'].user
    @users = BatchRun.fetch_report_preview_user(user.token).to_json
    now = Date.today
    @year = now.year
    @week = now.cweek
    @selected_user = Settings.ext.reporting.default_user
    @default_email = user.email
    slim :report_preview
  end
end
