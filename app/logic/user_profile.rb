# frozen_string_literal: true

require_relative 'user_profile/overview'
require_relative 'user_profile/detail'
require_relative 'user_profile/account_fn'

# Defines common use cases for user profiles (like formatting)
module UserProfile
  def self.search_for_users(token, search_string)
    search_terms = _parse_search_terms(search_string)

    if search_terms.size > 1
      _search_for_user_overview(token, search_terms)
    else
      _search_for_user_detail(token, search_terms)
    end
  end
end
