# frozen_string_literal: true

require 'net/http'
require 'uri'
require_relative '../http'

# Defines calls to the external user profile service
module ExtUserProfile
  def self.fetch_user_by_email(token, email)
    _fetch_user(token, { 'email' => email })
  end

  def self.fetch_user_by_id(token, user_id)
    _fetch_user(token, { 'userId' => user_id })
  end

  def self.search_for_user(token, search_string)
    users = []
    return users if search_string.empty?

    if URI::MailTo::EMAIL_REGEXP =~ search_string
      users.push(fetch_user(token, { 'email' => search_string }))
    elsif term.match?(/\A-?\d+\Z/)
      users.push(fetch_user(token, { 'userId' => search_string }))
    end

    users
  end

  def self._fetch_user(token, content)
    _post(
      uri: '/user/profile/search',
      payload: content,
      token: token,
      error_message: 'Unable to fetch users from userprofile'
    )
  end

  def self.fetch_current_user_profile(token)
    HTTP.get(
      uri: _create_url('/user/profile'),
      token: token,
      client_error_fn: method(:_handle_current_profile_client_error),
      error_class: UserProfileServiceError,
      error_message: 'Unable to fetch profile for current user'
    )
  end

  def self._handle_current_profile_client_error(resp)
    msg = if resp.is_a?(Net::HTTPBadRequest) && resp.body.include?('Unable to find profile with id')
            'UserProfile Service: The user doesn\'t exist'
          elsif resp.is_a? Net::HTTPForbidden
            "UserProfile Service: Forbidden (#{resp.code})"
          elsif resp.is_a? Net::HTTPUnauthorized
            "UserProfile Service: Unauthorized (#{resp.code})"
          else
            "UserProfile Service: (#{resp.code})"
          end

    raise UserProfileServiceError, msg
  end

  def self.fetch_working_groups(token, user_id)
    _get(
      uri: "/user/profile/#{user_id}/wg",
      token: token,
      error_message: 'Unable to fetch working groups from userprofile'
    )
  end
end
