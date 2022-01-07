# frozen_string_literal: true

require_relative '../ext/batch_run'

# This module all functionality for the Batch Run
module BatchRun
  def self.fetch_report_preview_mail(token, user, year, week)
    ExtBatchRun.fetch_report_preview_mail(token, user, year, week)
  end

  def self.fetch_report_preview_user(token)
    ExtBatchRun.fetch_report_preview_user(token)
               .map { |user| ReportTemplateUser.new(user) }
  end

  def self.send_report_preview_mail(token, user, year, week, mail_to)
    ExtBatchRun.send_report_preview_mail(token, user, year, week, mail_to)
  end

  def self.fetch_last_batch_run(token)
    ExtBatchRun.fetch_last_batch_run(token)
  end

  # Represents template users to load report preview emails
  class ReportTemplateUser
    def initialize(user_key)
      @key = user_key
      name_arr = user_key.gsub(/([[:lower:]\\d])([[:upper:]])/, '\1 \2') \
                         .gsub(/([^-\\d])(\\d[-\\d]*( |$))/, '\1 \2') \
                         .gsub(/([[:upper:]])([[:upper:]][[:lower:]\\d])/, '\1 \2')
                         .split
      @name = ''
      name_arr.each { |n| @name += " #{n.capitalize}" }
      @name = @name.strip
    end

    def as_json(_options = {})
      {
        value: @key,
        text: @name
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end
