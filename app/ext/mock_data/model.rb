# frozen_string_literal: true

# Module which contains all data
module MockData
  Role = Struct.new(:key, :name, :features, keyword_init: true)

  UserData = Struct.new(
    :user_id,
    :token,
    :email,
    :first_name,
    :last_name,
    :role,
    :activated,
    :activation_date,
    :timezone,
    :subscription,
    :sign_up_date,
    :last_signin_date,
    :possesses_api_credentials,
    :reset_password_code_creation_time,
    :reset_password_code_valid,
    :working_groups,
    keyword_init: true
  )

  WorkingGroup = Struct.new(:id, :name, :wg_members, :wg_pending_invites, :can_be_deleted)
  WGMember = Struct.new(:id, :first_name, :last_name, :join_date, :email, :role)
  WGPendingInvite = Struct.new(:email, :inviter, :invitation_date, :last_notification_date)

  def self._create_member_from_user(user, join_date, role)
    WGMember.new(
      id: user.user_id,
      first_name: user.first_name,
      last_name: user.last_name,
      join_date: join_date,
      role: role
    )
  end
end
