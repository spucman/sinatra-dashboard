# frozen_string_literal: true

require 'net/http'
require 'uri'
require_relative '../logger'

# Defines helper classes and methods for dealing with http
module 
  def self.get_request(uri, http_headers)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)

    http_headers&.each { |key, value| request[key] = value }

    http.request(request)
  rescue SocketError, EOFError => e
    handle_socket_error(e, uri)
  end

  def self.handle_socket_error(error, uri)
    logger.error("Unable to reach external service(#{uri}): #{error.message}")
    raise ConnectionFailedError, "Unable to reach external service(#{uri}): #{error.message}"
  end

  def self.create_json_headers(token = '')
    if token
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      }
    else
      { 'Content-Type' => 'application/json' }
    end
  end

  def self.post(uri:, payload:, token:, client_error_fn:, error_class:, error_message:) # rubocop:disable Metrics/ParameterLists
    resp = Net::HTTP.post(uri, payload, create_json_headers(token))

    return client_error_fn.call(resp) if resp.is_a? Net::HTTPClientError
    return JSON.parse(resp.body) if resp.is_a? Net::HTTPSuccess

    raise error_class, "#{error_message}: #{resp.code} = #{resp.body}"
  rescue SocketError, EOFError => e
    HTTP.handle_socket_error(e, uri)
  end

  def self.get(uri:, token:, client_error_fn:, error_class:, error_message:)
    resp = get_request(uri, create_json_headers(token))

    return client_error_fn.call(resp) if resp.is_a? Net::HTTPClientError
    return JSON.parse(resp.body) if resp.is_a? Net::HTTPSuccess

    raise error_class, "#{error_message}: #{resp.code} = #{resp.body}"
  rescue SocketError, EOFError => e
    HTTP.handle_socket_error(e, uri)
  end

  class ConnectionFailedError < RuntimeError; end
end
