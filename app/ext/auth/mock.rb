# frozen_string_literal: true

require 'json'
require 'webmock'
require_relative '../http'
require_relative '../mock_data'

# Defines calls to the external user profile service
module ExtAuth
  WebMock.enable!

  def self._create_sign_in_stub(user)
    email = user.email

    WebMock::API.stub_request(:post, _create_url('/user/sign-in'))
                .with(body: { 'email': email, 'password': email })
                .to_return(body: JSON.generate({ 'email': email, 'token': user.token, 'userId': user.user_id }))
  end

  def self._create_fetch_auth_meta_data_stub(token)
    MockData::ALL_USERS.each do |user|
      resp = _create_auth_meta_json_response(user)
      WebMock::API.stub_request(:post, _create_url('/user/search'))
                  .with(headers: HTTP.create_json_headers(token), body: { 'email': user.email })
                  .to_return(body: resp)

      WebMock::API.stub_request(:post, _create_url('/user/search'))
                  .with(headers: HTTP.create_json_headers(token), body: { 'userId': user.user_id })
                  .to_return(body: resp)
    end
  end

  def self._create_auth_meta_json_response(user) # rubocop:disable Metrics/MethodLength
    JSON.generate(
      {
        'data': {
          'signUpDate': user.sign_up_date,
          'lastSignInDate': user.last_signin_date,
          'activationDate': user.activation_date,
          'possessesApiCredentials': user.possesses_api_credentials,
          'resetPasswordCodeCreationTime': user.reset_password_code_creation_time,
          'resetPasswordCodeValid': user.reset_password_code_valid
        }
      }
    )
  end

  def self._create_activate_deactivate_user_stub(token)
    MockData::ALL_USERS.each do |affected_user|
      _create_activate_user_with_token_stub(token, affected_user.email)
      _create_deactivate_user_with_token_stub(token, affected_user.email)
    end
  end

  def self._create_activate_user_with_token_stub(token, email)
    WebMock::API.stub_request(:post, _create_url('/user/activate'))
                .with(headers: HTTP.create_json_headers(token), body: { 'email': email })
  end

  def self._create_deactivate_user_with_token_stub(token, email)
    WebMock::API.stub_request(:post, _create_url('/user/deactivate'))
                .with(headers: HTTP.create_json_headers(token), body: { 'email': email })
  end

  def self._create_send_reset_password_email_stub(email)
    WebMock::API.stub_request(:post, _create_url('/user/reset-password-mail'))
                .with(body: { 'email': email })
  end

  MockData::ALL_USERS.each do |user|
    _create_sign_in_stub(user)
    _create_activate_deactivate_user_stub(user.token)
    _create_send_reset_password_email_stub(user.email)
    _create_fetch_auth_meta_data_stub(user.token)
  end
end
