# frozen_string_literal: true

require 'net/http'
require 'json'
require_relative '../http'

# Defines calls to the external user profile service
module ExtAuth
  def self.authenticate_user(email, pwd)
    uri = _create_url('/user/sign-in')
    begin
      resp = Net::HTTP.post(uri, JSON.generate({ 'email' => email, 'password' => pwd }), HTTP.create_json_headers)

      _raise_authentication_error(resp) unless resp.is_a? Net::HTTPSuccess

      JSON.parse(resp.body)
    rescue SocketError, EOFError => e
      HTTP.handle_socket_error(e, uri)
    end
  end

  def self._raise_authentication_error(resp)
    raise AuthServiceError, "Unable to authenticate users: #{resp.code} = #{resp.body}"
  end
end
