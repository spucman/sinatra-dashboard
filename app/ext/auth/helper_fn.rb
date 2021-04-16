# frozen_string_literal: true

require 'net/http'
require 'uri'
require_relative '../http'

# Defines calls to the external user profile service
module ExtAuth
  def self._create_url(uri)
    URI("#{Settings.ext.auth_service.url}/rest/v1#{uri}")
  end

  def self._handle_client_error(resp)
    { 'error' => _create_error_msg(resp) }
  end

  def self._create_error_msg(resp)
    case resp
    when Net::HTTPNotFound
      'Auth Service: The user doesn\'t exist'
    when Net::HTTPForbidden
      "Auth Service: Forbidden (#{resp.code})"
    when Net::HTTPUnauthorized
      "Auth Service: Unauthorized (#{resp.code})"
    else
      "Auth Service: (#{resp.code})"
    end
  end

  def self._post(uri:, token:, payload:, error_message:)
    HTTP.post(
      uri: _create_rest_url(uri),
      payload: JSON.generate(payload),
      token: token,
      client_error_fn: method(:_handle_client_error),
      error_class: AuthServiceError,
      error_message: error_message
    )
  end

  class AuthServiceError < RuntimeError; end
end
