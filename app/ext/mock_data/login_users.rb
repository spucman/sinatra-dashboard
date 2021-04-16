# frozen_string_literal: true

# Module which contains all data
module MockData
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
    activation_date: '2021-02-03T04:05:06',
    sign_up_date: '2021-02-03T04:05:06',
    last_signin_date: '2021-04-03T04:05:06',
    possesses_api_credentials: true,
    reset_password_code_creation_time: nil,
    reset_password_code_valid: false,
    subscription: false,
    working_groups: []
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
    activation_date: '2021-02-03T04:05:06',
    sign_up_date: '2021-02-03T04:05:06',
    last_signin_date: '2021-04-03T04:05:06',
    possesses_api_credentials: true,
    reset_password_code_creation_time: nil,
    reset_password_code_valid: false,
    subscription: false,
    working_groups: []
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
    activation_date: '2021-02-03T04:05:06',
    sign_up_date: '2021-02-03T04:05:06',
    last_signin_date: '2021-04-03T04:05:06',
    possesses_api_credentials: true,
    reset_password_code_creation_time: '2021-04-03T04:05:06',
    reset_password_code_valid: false,
    subscription: false,
    working_groups: []
  )
end
