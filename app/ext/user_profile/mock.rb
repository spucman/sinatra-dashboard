# frozen_string_literal: true

require 'json'
require 'webmock'
require_relative '../http'
require_relative '../mock_user'

# Defines calls to the external user profile service
module ExtUserProfile
  WebMock.enable!

  _create_fetch_current_profile_stub(MockUser::FULL_ACCESS_USER)
  _create_fetch_current_profile_stub(MockUser::USER_ACCESS_USER)
  _create_fetch_current_profile_stub(MockUser::REPORT_ACCESS_USER)

  _create_fetch_user_stub(MockUser::FULL_ACCESS_USER.token)
  _create_fetch_user_stub(MockUser::USER_ACCESS_USER.token)

  def self._create_fetch_current_profile_stub(user)
    WebMock::API.stub_request(:get, _create_url('/user/profile'))
                .with(headers: HTTP.create_json_headers(user.token))
                .to_return(body: _create_up_json_response(user))
  end

  def self._create_fetch_user_stub(token)
    MockUser::ALL_USERS.each do |return_user|
      resp = _create_up_json_response(return_user)
      WebMock::API.stub_request(:post, _create_url('/user/profile/search'))
                  .with(headers: HTTP.create_json_headers(token), body: { 'user_id': return_user.user_id })
                  .to_return(body: resp)

      WebMock::API.stub_request(:post, _create_url('/user/profile/search'))
                  .with(headers: HTTP.create_json_headers(token), body: { 'email': return_user.email })
                  .to_return(body: resp)
    end
  end

  def self._create_fetch_working_groups_stub()
  end

  def self._create_up_json_response(user)
    JSON.generate(
      {
        'data': {
          'userId': user.user_id,
          'firstName': user.first_name,
          'lastName': user.last_name,
          'email': user.email,
          'role': {
            'key': user.role.key,
            'name': user.role.name,
            'features': user.role.features
          },
          'activated': user.activated,
          'timezone': user.timezone,
          'newsletterSubscription': user.subscription
        }
      }
    )
  end
end
