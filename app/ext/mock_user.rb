# frozen_string_literal: true

require_relative ''

module MockUser
  Role = Struct.new(:key, :name, :features, keyword_init: true)
  UserData = Struct.new(
    :user_id,
    :token,
    :email,
    :first_name,
    :last_name,
    :role,
    :activated,
    :timezone,
    :subscription,
    keyword_init: true
  )

  ALL_USERS = [FULL_ACCESS_USER, USER_ACCESS_USER, REPORT_ACCESS_USER].freeze

  FULL_ACCESS_USER = UserData.new(
    user_id: '1',
    token: 'adminToken',
    email: 'admin@example.com',
    first_name: 'John',
    last_name: 'Doe',
    role: Role.new(
      key: 'admin',
      name: 'Administrator',
      features: [
        'feature.dashboard.userprofile.switch-role',
        'feature.dashboard.login',
        'feature.dashboard.userprofile.revoke-token',
        'feature.dashboard.userprofile',
        'feature.dashboard.userprofile.exceed-grace-period',
        'feature.dashboard.report.preview',
        'feature.dashboard.userprofile.deactivate'
      ]
    ),
    activated: true,
    timezone: 'UTC+00:00',
    subscription: false
  )

  USER_ACCESS_USER = UserData.new(
    user_id: '2',
    token: 'userToken',
    email: 'user@example.com',
    first_name: 'Sue',
    last_name: 'Doe',
    role: Role.new(
      key: 'user',
      name: 'User Manager',
      features: [
        'feature.dashboard.userprofile.switch-role',
        'feature.dashboard.login',
        'feature.dashboard.userprofile.revoke-token',
        'feature.dashboard.userprofile',
        'feature.dashboard.userprofile.exceed-grace-period',
        'feature.dashboard.userprofile.deactivate'
      ]
    ),
    activated: true,
    timezone: 'UTC+00:00',
    subscription: false
  )

  REPORT_ACCESS_USER = UserData.new(
    user_id: '3',
    token: 'reportToken',
    email: 'report@example.com',
    first_name: 'Lisa',
    last_name: 'Doe',
    role: Role.new(
      key: 'report',
      name: 'Report Manager',
      features: [
        'feature.dashboard.login',
        'feature.dashboard.report.preview'
      ]
    ),
    activated: true,
    timezone: 'UTC+00:00',
    subscription: false
  )
end
