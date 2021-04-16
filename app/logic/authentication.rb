# frozen_string_literal: true

require_relative '../ext/auth'
require_relative '../ext/user_profile'
require_relative 'feature'
require_relative '../logger'

# This module handles the authentication and authorization
module Authentication
  def self.authenticate_user(email, pwd)
    auth_map = ExtAuth.authenticate_user(email, pwd)
    up_map = ExtUserProfile.fetch_current_user_profile(auth_map['token'])

    SessionUser.parse_from_external_services(auth_map, up_map)
  rescue ExtAuth::AuthServiceError
    raise AuthenticationFailedError, 'The username and password combination is invalid!'
  rescue ExtUserProfile::UserProfileServiceError => e
    logger.warn("User (#{auth_map['userId']}) tries to authorize himself to the admin dashboard: #{e.message}")
    raise AuthenticationFailedError, 'Unable to to authorize user!'
  rescue HTTP::ConnectionFailedError
    raise AuthenticationFailedError, 'Unable to authenticate user, please try again!'
  end

  # Defines an authorized user
  class SessionUser
    attr_reader :token, :features, :email

    def self.parse_from_external_services(auth_map, up_map) # rubocop:disable Metrics/AbcSize
      map = {}
      map['user_id'] = auth_map['userId']
      map['token'] = auth_map['token']

      data = up_map['data']
      map['first_name'] = data['firstName']
      map['last_name'] = data['lastName']
      map['email'] = data['email']
      map['role'] = data['role']['name']
      map['features'] = data['role']['features']

      SessionUser.new(map)
    end

    def initialize(map)
      @user_id = map['user_id']
      @token = map['token']
      @first_name = map['first_name']
      @last_name = map['last_name']
      @email = map['email']
      @role = map['role']
      @features = map['features']
    end

    def allowed_to_login?
      @features.include?(Feature::DASHBOARD_LOGIN)
    end

    def feature?(feature)
      @features.include?(feature)
    end

    def allowed_to_deactivate_profile?
      @features.include?(Feature::DASHBOARD_USER_PROFILE_DEACTIVATE)
    end

    def allowed_to_revoke_tokens?
      @features.include?(Feature::DASHBOARD_USER_PROFILE_REVOKE_TOKEN)
    end

    def allowed_to_switch_product_plan?
      @features.include?(Feature::DASHBOARD_USER_PROFILE_SWITCH_PRODUCT_PLAN)
    end

    def as_json(_options = {})
      {
        user_id: @user_id,
        token: @token,
        first_name: @first_name,
        last_name: @last_name,
        email: @email,
        role: @role,
        features: @features
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end

  class AuthenticationFailedError < RuntimeError; end
end
