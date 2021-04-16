# frozen_string_literal: true

require 'logger'

def logger
  logger = Logger.new($stdout)

  logger.level = parse_log_level(Settings.log_level)
  logger.formatter = proc { |severity, datetime, progname, msg|
    date_format = datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')
    "#{date_format} #{severity}  [#{progname}] | userId requestId | #{msg}\n"
  }
  logger
end

def parse_log_level(str_log_level)
  case str_log_level.to_s.strip.upcase
  when 'DEBUG'
    Logger::DEBUG
  when 'WARN'
    Logger::WARN
  when 'ERROR'
    Logger::ERROR
  else
    Logger::INFO
  end
end
