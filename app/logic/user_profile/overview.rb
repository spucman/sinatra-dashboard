# frozen_string_literal: true

require_relative '../../ext/user_profile'

# Defines common use cases for user profiles (like formatting)
module UserProfile
  def self.search_for_user_overview(token, search_string)
    search_terms = _parse_search_terms(search_string)

    _search_for_user_overview(token, search_terms)
  end

  def self._search_for_user_overview(token, search_terms)
    users = []
    search_terms.uniq.each do |term|
      res = _fetch_user_for_user_overview(token, term)
      users.push(OverviewUser.new(res)) unless res.nil?
    end

    users
  end

  def self._parse_search_terms(search_string)
    return [] if search_string.nil?

    input_terms = search_string.strip.split(',')
    return [] if input_terms.empty?

    search_terms = []
    input_terms.each do |term|
      tmp = term.strip
      search_terms.push(tmp) unless tmp.empty?
    end
    search_terms
  end

  def self._fetch_user_for_user_overview(token, search_string)
    if URI::MailTo::EMAIL_REGEXP =~ search_string
      ExtUserProfile.fetch_user_by_email(token, search_string)
    elsif search_string.match?(/\A-?\d+\Z/)
      ExtUserProfile.fetch_user_by_id(token, search_string)
    end
  end

  # defining a user for the overview page with basic information
  class OverviewUser
    def initialize(map)
      if map['error'].nil?
        _create_user(map)
      else
        _create_user_with_error(map)
      end
    end

    def _create_user_with_error(map)
      @user_id = map['userId']
      @name = map['error'] || 'N/A'
    end

    def _create_user(map)
      data = map['data']
      @user_id = data['userId']
      @name = "#{data['firstName']} #{data['lastName']}"
      @email = data['email']
      @activated = data['activated']
      @product_plan = data['role']['name']
      @timezone = data['timezone']
    end

    def as_json(_options = {})
      {
        user_id: @user_id,
        name: @name,
        email: @email,
        activated: @activated,
        product_plan: @product_plan,
        timezone: @timezone
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
