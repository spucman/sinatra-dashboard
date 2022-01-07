# frozen_string_literal: true

require 'net/http'
require_relative '../http'

# Defines calls to one authentiation service
module ExtAuth
  def self.fetch_auth_meta_data_by_email(token, email)
    _fetch_auth_meta_data(token, { email: })
  end

  def self.fetch_auth_meta_data_by_id(token, user_id)
    _fetch_auth_meta_data(token, { userId: user_id })
  end

  def self._fetch_auth_meta_data(token, content)
    _post(
      uri: '/user/search',
      token:,
      payload: content,
      error_message: 'Unable to fetch users from auth-service'
    )
  end

  def self.activate_user(token, email)
    _post(
      uri: '/user/activate',
      token:,
      payload: { email: },
      error_message: 'Unable to activate user in auth-service'
    )
  end

  def self.deactivate_user(token, email)
    _post(
      uri: '/user/deactivate',
      token:,
      payload: { email: },
      error_message: 'Unable to deactivate user in auth service'
    )
  end

  def self.send_reset_password_email(email)
    _post(
      uri: '/user/reset-password-mail',
      payload: { email: },
      error_message: 'Unable to send reset password email from auth'
    )
  end

  def self.logout_user_from_all_devices(token, user_id)
    _post(
      uri: '/user/revoke-access',
      token:,
      payload: { userId: user_id },
      error_message: 'Unable to logout user in authtoken service'
    )
  end
end
