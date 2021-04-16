# frozen_string_literal: true

require 'json'
require 'webmock'
require_relative '../http'
require_relative '../mock_user'

# Defines calls to the external user profile service
module ExtAuth
  WebMock.enable!

  MockUser::ALL_USERS.each do |user|
    _create_sign_in_stub(user)
    _activate_deactivate_user(user.token)
    _send_reset_password_email(user.email)
  end

  def self._create_sign_in_stub(user)
    email = user.email

    WebMock::API.stub_request(:post, _create_url('/user/sign-in'))
                .with(body: { 'email': email, 'password': email })
                .to_return(body: JSON.generate({ 'email': email, 'token': user.token, 'userId': user.user_id }))
  end

  def self._activate_deactivate_user(token)
    MockUser::ALL_USERS.each do |affected_user|
      _activate_user_with_token(token, affected_user.email)
      _deactivate_user_with_token(token, affected_user.email)
    end
  end

  def self._activate_user_with_token(token, email)
    WebMock::API.stub_request(:post, _create_url('/user/activate'))
                .with(headers: HTTP.create_json_headers(token), body: { 'email': email })
  end

  def self._deactivate_user_with_token(token, email)
    WebMock::API.stub_request(:post, _create_url('/user/deactivate'))
                .with(headers: HTTP.create_json_headers(token), body: { 'email': email })
  end

  def self._send_reset_password_email(email)
    WebMock::API.stub_request(:post, _create_url('/user/reset-password-mail'))
                .with(body: { 'email': email })
  end
end
