# frozen_string_literal: true

require_relative 'mock_data/model'
require_relative 'mock_data/login_users'
require_relative 'mock_data/working_groups'
require_relative 'mock_data/batch_run'

module MockData
  ALL_USERS = [FULL_ACCESS_USER, USER_ACCESS_USER, REPORT_ACCESS_USER].freeze
end
