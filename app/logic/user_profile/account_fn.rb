# frozen_string_literal: true

require_relative '../../ext/user_profile'
require_relative '../../ext/auth'

# Defines support functions applied to user profiles
module UserProfile
  def self.activate_user(token, email)
    ExtAuth.activate_user(token, email)
  end

  def self.deactivate_user(token, email)
    ExtAuth.deactivate_user(token, email)
  end

  def self.send_reset_password_email(email)
    ExtAuth.send_reset_password_email(email)
  end

  def self.logout_user_from_all_devices(user_id)
    ExtAuth.logout_user_from_all_devices(user_id)
  end
end
