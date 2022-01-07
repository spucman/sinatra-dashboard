# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../../../logic/batch_run'
require_relative '../../../logic/feature'
require_relative '../../../ext/http'
require_relative '../../../ext/batch_run'
require_relative 'validator'

# Entry Point for all rest report requests
class Rest < Sinatra::Base
  get '/rest/v1/report/weekly/runs/last', auth: Feature::DASHBOARD_REPORT_PREVIEW do
    token = env['warden'].user.token

    JSON.generate(BatchRun.fetch_last_batch_run(token))
  end

  get '/rest/v1/report/weekly/preview/users', auth: Feature::DASHBOARD_REPORT_PREVIEW do
    token = env['warden'].user.token

    BatchRun.fetch_report_preview_user(token).to_json
  end

  get '/rest/v1/report/weekly/preview', auth: Feature::DASHBOARD_REPORT_PREVIEW do
    token = env['warden'].user.token
    user = params['user']
    year = params['year']
    week = params['week']

    content_type :html
    return _create_error('No user found') if user.to_s.strip.empty?
    return _create_error('Invalid year found') unless number_between?(year, 1970, 2500)
    return _create_error('Invalid week') unless number_between?(week, 1, 52)
    return slim :'errors/br_in_the_past' if in_the_past?(week, year)

    begin
      BatchRun.fetch_report_preview_mail(token, user, year, week)
    rescue ConnectionFailedError, BatchReportingServiceError
      slim :'errors/br_unloadable'
    end
  end

  post '/rest/v1/report/weekly/preview/send', auth: Feature::DASHBOARD_REPORT_PREVIEW do
    token = env['warden'].user.token
    user = params['user']
    year = params['year']
    week = params['week']
    mail_to = params['email']

    return _create_error('No user found') if user.to_s.strip.empty?
    return _create_error('Invalid year found') unless number_between?(year, 1970, 2500)
    return _create_error('Invalid week') unless number_between?(week, 1, 52)
    return _create_error('Week/Year is not allowed to be in the past') if in_the_past?(week, year)

    BatchRun.send_report_preview_mail(token, user, year, week, mail_to)
  end
end
