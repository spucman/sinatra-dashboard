# frozen_string_literal: true

require 'json'
require 'webmock'
require_relative '../http'
require_relative '../mock_data'

# Defines calls to the external batch run service
module ExtBatchRun
  WebMock.enable!

  def self._create_fetch_report_preview_user_stub(token)
    WebMock::API.stub_request(:get, _create_private_url('/preview/reporting/weekly/preview/users'))
                .with(headers: HTTP.create_json_headers(token))
                .to_return(body: JSON.generate({}))
  end

  def self._create_fetch_report_preview_mail_stub(token)
    WebMock::API.stub_request(:get, _create_private_url('/preview/reporting/weekly/preview'))
                .with(headers: HTTP.create_json_headers(token))
                .to_return(body: '<html><head></head><body><h1>test</h1></body></html>')
  end

  def self._create_send_report_preview_mail_stub(token)
    WebMock::API.stub_request(:get, _create_private_url('/preview/reporting/weekly/preview/send'))
                .with(headers: HTTP.create_json_headers(token))
                .to_return(body: JSON.generate({}))
  end

  def self._create_fetch_last_batch_run_stub(token) # rubocop:disable Metrics/MethodLength
    runs = []
    MockData::BATCH_RUN.each do |run|
      runs << {
        'timezone' => run.timezone,
        'success' => run.success_count,
        'failure' => run.failure_count
      }
    end
    WebMock::API.stub_request(:get, _create_private_url('/run/last'))
                .with(headers: HTTP.create_json_headers(token))
                .to_return(body: JSON.generate(runs))
  end

  [MockData::FULL_ACCESS_USER.token, MockData::REPORT_ACCESS_USER.token].each do |token|
    _create_send_report_preview_mail_stub(token)
    _create_fetch_last_batch_run_stub(token)
    _create_fetch_report_preview_mail_stub(token)
    _create_fetch_report_preview_user_stub(token)
  end
  # _create_send_report_preview_mail_stub(MockData::FULL_ACCESS_USER.token)
  # _create_send_report_preview_mail_stub(MockData::REPORT_ACCESS_USER.token)
  # _create_fetch_last_batch_run_stub(MockData::FULL_ACCESS_USER.token)
  # _create_fetch_last_batch_run_stub(MockData::REPORT_ACCESS_USER.token)
  # _create_fetch_report_preview_mail_stub(MockData::FULL_ACCESS_USER.token)
  # _create_fetch_report_preview_mail_stub(MockData::FULL_ACCESS_USER.token)
end
