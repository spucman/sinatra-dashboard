# frozen_string_literal: true

require 'json'
require 'webmock'
require_relative '../http'
require_relative '../mock_data'

# Defines calls to the external user profile service
module ExtUserProfile
  WebMock.enable!

  _create_fetch_current_profile_stub(MockData::FULL_ACCESS_USER)
  _create_fetch_current_profile_stub(MockData::USER_ACCESS_USER)
  _create_fetch_current_profile_stub(MockData::REPORT_ACCESS_USER)

  _create_fetch_user_stub(MockData::FULL_ACCESS_USER.token)
  _create_fetch_user_stub(MockData::USER_ACCESS_USER.token)
  _create_fetch_working_groups_stub(MockData::FULL_ACCESS_USER.token)
  _create_fetch_working_groups_stub(MockData::USER_ACCESS_USER.token)

  def self._create_fetch_current_profile_stub(user)
    WebMock::API.stub_request(:get, _create_url('/user/profile'))
                .with(headers: HTTP.create_json_headers(user.token))
                .to_return(body: _create_up_json_response(user))
  end

  def self._create_fetch_user_stub(token)
    MockData::ALL_USERS.each do |return_user|
      resp = _create_up_json_response(return_user)
      WebMock::API.stub_request(:post, _create_url('/user/profile/search'))
                  .with(headers: HTTP.create_json_headers(token), body: { 'user_id': return_user.user_id })
                  .to_return(body: resp)

      WebMock::API.stub_request(:post, _create_url('/user/profile/search'))
                  .with(headers: HTTP.create_json_headers(token), body: { 'email': return_user.email })
                  .to_return(body: resp)
    end
  end

  def self._create_fetch_working_groups_stub(token)
    MockData::ALL_USERS.each do |user|
      WebMock::API.stub_request(:get, _create_url("/user/profile/#{user.user_id}/wg"))
                  .with(headers: HTTP.create_json_headers(token))
                  .to_return(body: _create_wg_json_response(user))
    end
  end

  def self._create_up_json_response(user) # rubocop:disable Metrics/MethodLength
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

  def self._create_wg_json_response(user) # rubocop:disable Metrics/MethodLength
    working_groups = []
    user.working_groups.each do |wg|
      working_groups << _create_wg(wg)
    end

    JSON.generate(
      {
        'data': {
          'workingGroups': working_groups
        }
      }
    )
  end

  def self._create_wg(working_group)  # rubocop:disable Metrics/MethodLength
    members = []
    working_group.wg_members.each do |m|
      members << _create_wg_member(m)
    end

    pending_invites = []
    working_group.wg_pending_invites.each do |inv|
      pending_invites << _create_wg_pending_invite(inv)
    end

    {
      'id': wworking_groupg.id,
      'name': working_group.name,
      'members': members,
      'pendingInvites': pending_invites,
      'canBeDeleted': working_group.can_be_deleted
    }
  end

  def self._create_wg_member(member)
    {
      'id': member.user_id,
      'firstName': member.first_name,
      'lastName': member.last_name,
      'email': member.email,
      'joinDate': member.join_date,
      'role': member.role
    }
  end

  def self._create_wg_pending_invite(invite)
    {
      'email': invite.email,
      'inviter': invite.inviter,
      'invitationDate': invite.invitation_date,
      'lastNotificationDate': invite.last_notification_date
    }
  end
end
