# frozen_string_literal: true

# Module which contains all data
module MockData
  WORKING_GROUP_1 = WorkingGroup.new(
    id: '1',
    name: 'Working Group 1',
    wg_members: [
      _create_member_from_user(FULL_ACCESS_USER, '2021-04-03T04:05:06', 'Admin'),
      _create_member_from_user(USER_ACCESS_USER, '2021-04-03T05:05:06', 'Member')
    ],
    wg_pending_invites: [
      WGPendingInvite.new(
        email: REPORT_ACCESS_USER.email,
        inviter: FULL_ACCESS_USER.email,
        invitation_date: '2021-04-03T05:10:06',
        last_notification_date: '2021-04-03T05:10:06'
      )
    ],
    can_be_deleted: false
  )

  WORKING_GROUP_2 = WorkingGroup.new(
    id: '2',
    name: 'Working Group 2',
    wg_members: [
      _create_member_from_user(FULL_ACCESS_USER, '2021-04-03T04:05:06', 'Admin'),
      _create_member_from_user(USER_ACCESS_USER, '2021-04-03T05:05:06', 'Member'),
      _create_member_from_user(REPORT_ACCESS_USER, '2021-04-03T05:10:06', 'Member')
    ],
    wg_pending_invites: [],
    can_be_deleted: true
  )

  FULL_ACCESS_USER.working_groups = [
    WORKING_GROUP_1,
    WORKING_GROUP_2
  ]

  USER_ACCESS_USER.working_groups = [
    WORKING_GROUP_1,
    WORKING_GROUP_2
  ]

  REPORT_ACCESS_USER.working_groups = [
    WORKING_GROUP_1,
    WORKING_GROUP_2
  ]
end
