# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'
require_relative '../http'

# Defines calls to the external user profile service
module ExtUserProfile
  class UserProfileServiceError < RuntimeError; end

  def self._create_url(uri)
    URI("#{Settings.ext.userprofile.url}/rest/v1#{uri}")
  end

  def self._handle_client_error(resp)
    { 'error' => _create_error_msg(resp) }
  end

  def self._create_error_msg(resp)
    if resp.is_a?(Net::HTTPBadRequest) && resp.body.include?('Unable to find profile with id')
      'UserProfile Service: The user doesn\'t exist'
    elsif resp.is_a? Net::HTTPForbidden
      "UserProfile Service: Forbidden (#{resp.code})"
    elsif resp.is_a? Net::HTTPUnauthorized
      "UserProfile Service: Unauthorized (#{resp.code})"
    else
      "UserProfile Service: (#{resp.code})"
    end
  end

  def self._post(uri:, token:, payload:, error_message:)
    HTTP.post(
      uri: _create_url(uri),
      payload: JSON.generate(payload),
      token:,
      client_error_fn: method(:_handle_client_error),
      error_class: UserProfileServiceError,
      error_message:
    )
  end

  def self._get(uri:, token:, error_message:)
    HTTP.get(
      uri: _create_url(uri),
      token:,
      client_error_fn: method(:_handle_client_error),
      error_class: UserProfileServiceError,
      error_message:
    )
  end
end
