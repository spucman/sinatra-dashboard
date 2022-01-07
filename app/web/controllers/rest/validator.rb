# frozen_string_literal: true

require 'date'
require 'uri'

SUPPORTED_ROLES = ['pro', 'basic'].freeze

def mail?(email)
  return false if email.nil?
  return false if email.to_s.strip.empty?

  return true if URI::MailTo::EMAIL_REGEXP =~ email.to_s

  false
end

def valid_role?(role)
  SUPPORTED_ROLES.include? role.to_s.strip.downcase
end

def number_between?(value, lower, upper)
  stripped = value.to_s.strip
  return false if stripped.empty?

  num = stripped.to_i
  return true if lower <= num && num <= upper

  false
end

def in_the_past?(week, year)
  return false if week.nil? || year.nil?

  w_str = week.to_s.strip
  y_str = year.to_s.strip

  return false if w_str.empty? || y_str.empty?

  w = w_str.to_i
  y = y_str.to_i
  now = Date.today
  return false if now.year <= y && now.cweek <= w

  true
end
