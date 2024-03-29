# frozen_string_literal: true

require_relative '../../ext/user_profile'
require_relative '../../ext/auth'
require_relative '../converter'

# Defines common use cases for user profiles (like formatting)
module UserProfile
  def self.search_for_user_detail(token, search_string)
    search_terms = _parse_search_terms(search_string)

    _search_for_user_detail(token, search_terms)
  end

  def self._search_for_user_detail(token, search_terms)
    users = []
    search_terms.uniq.each do |term|
      up_res = _fetch_user_from_up_for_user_details(token, term)
      auth_res = _fetch_auth_meta_data(token, term)
      users << User.new(auth_res, up_res) unless up_res.nil?
    end

    users
  end

  def self._fetch_user_from_up_for_user_details(token, search_string)
    if URI::MailTo::EMAIL_REGEXP =~ search_string
      ExtUserProfile.fetch_user_by_email(token, search_string)
    elsif search_string.match?(/\A-?\d+\Z/)
      ExtUserProfile.fetch_user_by_id(token, search_string)
    end
  end

  def self._fetch_auth_meta_data(token, search_string)
    if URI::MailTo::EMAIL_REGEXP =~ search_string
      ExtAuth.fetch_auth_meta_data_by_email(token, search_string)
    elsif search_string.match?(/\A-?\d+\Z/)
      ExtAuth.fetch_auth_meta_data_by_id(token, search_string)
    end
  end

  def self.fetch_working_groups(token, user_id)
    wk = ExtUserProfile.fetch_working_groups(token, user_id)

    return wk unless wk['error'].nil?

    wk['data']
  end

  # Represents details of a searched user
  class User
    def initialize(auth_map, up_map)
      _initialize_up_data(up_map)
      _initialize_auth_data(auth_map)
      @out_of_sync = _find_out_of_sync_fields(up_map, auth_map)
    end

    def _initialize_up_data(map)
      if map['error'].nil?
        _assign_up_data(map['data'])
      else
        (@error ||= []) << (map['error'] || 'N/A')
      end
    end

    def _assign_up_data(data)
      @user_id = data['userId']
      @name = "#{data['firstName']} #{data['lastName']}"
      @email = data['email']
      @activated = data['activated']
      @role_name = "#{data['role']['name']} (#{data['role']['key']})"
      @role_key = data['role']['key']
      @timezone = data['timezone']
      @report_subscription = data['reportSubscription']
    end

    def _initialize_auth_data(map)
      if map['error'].nil?
        _assign_auth_data(map)
      else
        (@error ||= []) << (map['error'] || 'N/A')
      end
    end

    def _assign_auth_data(map)
      data = map['data']
      @sign_up_date = Converter.to_user_friendly_date_str(data['signUpDate'])
      @last_signin_date = Converter.to_user_friendly_date_str(data['lastSignInDate'])
      @activation_date = Converter.to_user_friendly_date_str(data['activationDate'])
      @possesses_api_credentials = data['possessesApiCredentials']
      @reset_password_code_creation_time = Converter.to_user_friendly_date_str(data['resetPasswordCodeCreationTime'])
      @reset_password_code_valid = data['resetPasswordCodeValid']
    end

    def _find_out_of_sync_fields(up_map, auth_map)
      _get_out_of_sync_fields(up_map['data'], auth_map) if up_map['error'].nil? && auth_map['error'].nil?
    end

    def _get_out_of_sync_fields(up_data, auth_data) # rubocop:disable Metrics/AbcSize
      out_of_sync = []
      out_of_sync << 'firstName' unless up_data['firstName'] == auth_data['firstName']
      out_of_sync << 'lastName' unless up_data['lastName'] == auth_data['lastName']
      out_of_sync << 'email' unless up_data['email'] == auth_data['email']
      out_of_sync << 'activated' unless up_data['activated'] == auth_data['active']
      out_of_sync << 'userId' unless up_data['userId'] == auth_data['userId']&.to_s
      out_of_sync
    end

    def as_json(_options = {}) # rubocop:disable Metrics/MethodLength
      {
        user_id: @user_id,
        name: @name,
        email: @email,
        activated: @activated,
        role_name: @role_name,
        role_key: @role_key,
        timezone: @timezone,
        report_subscription: @report_subscription,
        sign_up_date: @sign_up_date,
        last_signin_date: @last_signin_date,
        activation_date: @activation_date,
        possesses_api_credentials: @possesses_api_credentials,
        reset_password_code_creation_time: @reset_password_code_creation_time,
        reset_password_code_valid: @reset_password_code_valid,
        error: @error
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
