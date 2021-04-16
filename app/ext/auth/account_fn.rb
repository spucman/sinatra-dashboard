# frozen_string_literal: true

require 'net/http'
require_relative '../http'

# Defines calls to one authentiation service
module ExtAuth
  def self.activate_user(token, email)
    _post(
      uri: '/user/activate',
      token: token,
      payload: { 'email' => email },
      error_message: 'Unable to activate user in auth-service'
    )
  end

  def self.deactivate_user(token, email)
    _post(
      uri: '/user/deactivate',
      token: token,
      payload: { 'email': email },
      error_message: 'Unable to deactivate user in auth service'
    )
  end

  def self.send_reset_password_email(email)
    _post(
      uri: '/user/reset-password-mail',
      payload: { 'email' => email },
      error_message: 'Unable to send reset password email from auth'
    )
  end

  def self.logout_user_from_all_devices(token, user_id)
    _post(
      uri: '/user/revoke-access',
      token: token,
      payload: { 'userId' : user_id },
      error_message: 'Unable to logout user in authtoken service'
    )
  end
end
