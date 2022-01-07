# frozen_string_literal: true

require 'cgi'
require 'json'
require 'uri'
require_relative '../http'

# Defines calls to the external batch run service
module ExtBatchRun
  def self.fetch_report_preview_user(token)
    HTTP.get(
      uri: _create_private_url('/preview/reporting/weekly/preview/users'),
      token:,
      client_error_fn: method(:_handle_client_error),
      error_class: BatchRunServiceError,
      error_message: 'Unable to fetch preview users'
    )
  end

  def self.fetch_report_preview_mail(token, user, year, week)
    uri = "/preview/reporting/weekly/preview?week=#{CGI.escape(week)}&year=#{CGI.escape(year)}"
    uri += "&templateUser=#{CGI.escape(user)}" unless user.strip.empty?

    resp = HTTP.get_request(_create_private_url(uri), { 'Authorization' => "Bearer #{token}" })

    return _handle_client_error if resp.is_a? Net::HTTPClientError
    return resp.body if resp.is_a? Net::HTTPSuccess

    raise BatchRunServiceError, "Unable to fetch preview email: #{resp.code} = #{resp.body}"
  rescue SocketError, EOFError => e
    HTTP.handle_socket_error(e, uri)
  end

  def self.send_report_preview_mail(token, user, year, week, mail_to)
    p_week = CGI.escape(week)
    p_year = CGI.escape(year)
    p_mail = CGI.escape(mail_to)
    uri = "/preview/reporting/weekly/preview/send?week=#{p_week}&year=#{p_year}&mailTo=#{p_mail}"
    uri += "&templateUser=#{CGI.escape(user)}" unless user.strip.empty?

    resp = HTTP.get_request(_create_private_url(uri), { 'Authorization' => "Bearer #{token}" })

    return _handle_client_error if resp.is_a? Net::HTTPClientError
    return true if resp.is_a? Net::HTTPSuccess
  rescue SocketError, EOFError => e
    HTTP.handle_socket_error(e, uri)
  end

  def self.fetch_last_batch_run(token)
    HTTP.get(
      uri: _create_private_url('/run/last'),
      token:,
      client_error_fn: method(:_handle_client_error),
      error_class: BatchRunServiceError,
      error_message: 'Unable to fetch last batch run'
    )
  end

  def self._create_private_url(uri)
    cfg = Settings.ext.reporting
    URI("#{cfg.url}/private/rest/v1#{uri}")
  end

  def self._handle_client_error(resp)
    { 'error' =>  _create_error_msg(resp) }
  end

  def self._create_error_msg(resp)
    case resp
    when Net::HTTPForbidden
      "BatchRun Service: Forbidden (#{resp.code})"
    when Net::HTTPUnauthorized
      "BatchRun Service: Unauthorized (#{resp.code})"
    else
      "BatchRun Service: (#{resp.code})"
    end
  end

  class BatchRunServiceError < RuntimeError; end
end
