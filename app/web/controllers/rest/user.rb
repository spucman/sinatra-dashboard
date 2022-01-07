# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../../../logic/user_profile'
require_relative '../../../logic/feature'
require_relative 'validator'

# Entry Point for all rest requests
class Rest < Sinatra::Base
  post '/rest/v1/user/search', auth: Feature::DASHBOARD_UP do
    token = env['warden'].user.token

    JSON.generate(UserProfile.search_for_users(token, params['searchTerm']))
  end

  get '/rest/v1/user/:user_id/wg', auth: Feature::DASHBOARD_UP do |user_id|
    token = env['warden'].user.token

    JSON.generate(UserProfile.fetch_working_groups(token, user_id))
  end

  post '/rest/v1/user/activate', auth: Feature::DASHBOARD_UP do
    token = env['warden'].user.token
    email = params['email']

    return _create_error('Not a valid email address'), 400 unless email?(email)

    UserProfile.activate_user(token, email).to_json
  end

  post '/rest/v1/user/:user_id/deactivate', auth: Feature::DASHBOARD_UP_DEACTIVATE do |user_id|
    return _create_disabled_feature_msg, 403 unless Settings.feature.exceed_grace_period.enabled

    token = env['warden'].user.token
    UserProfile.deactivate_user(token, user_id).to_json
  end

  post '/rest/v1/user/password/reset', auth: Feature::DASHBOARD_UP do
    email = params['email']

    return _create_error('Not a valid email address'), 400 unless email?(email)

    UserProfile.send_reset_password_email(email)
  end

  get '/rest/v1/user/:user_id/logout', auth: Feature::DASHBOARD_UP_REVOKE_TOKEN do |user_id|
    UserProfile.logout_user_from_all_devices(user_id)
  end

  post '/rest/v1/user/role', auth: Feature::DASHBOARD_UP_SWITCH_ROLE do
    return _create_disabled_feature_msg, 403 unless Settings.feature.change_subscription.enabled

    token = env['warden'].user.token
    email = params['email']
    role = params['role']

    return _create_error('Not a valid email address'), 400 unless email?(email)
    return _create_error('Not a valid role'), 400 unless valid_role?(email)

    UserProfile.set_subcription(token, email, role)
  end
end
