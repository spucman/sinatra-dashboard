# frozen_string_literal: true

require 'date'

# This module holds helper functions which converts between data types or type formats
module Converter
  def self.to_user_friendly_date_str(input_str)
    return nil if input_str.nil? || input_str.empty?

    DateTime.iso8601(input_str).strftime('%F %H:%M:%S')
  end
end
