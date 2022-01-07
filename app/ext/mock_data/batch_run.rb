# frozen_string_literal: true

# Module which contains all data
module MockData
  BATCH_RUN = [
    BatchRunData.new(timezone: 'UTC+14:00', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+13:45', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+13:00', success_count: 20, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+12:00', success_count: 12, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+11:00', success_count: 48, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+10:30', success_count: 7, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+10:00', success_count: 25, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+09:30', success_count: 1, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+08:45', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+08:00', success_count: 53, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+07:00', success_count: 13, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+06:30', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+06:00', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+05:45', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+05:30', success_count: 10, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+05:00', success_count: 1, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+04:30', success_count: 1, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+04:00', success_count: 7, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+03:30', success_count: 1, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+03:00', success_count: 71, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+02:00', success_count: 2063, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+01:00', success_count: 4719, failure_count: 0),
    BatchRunData.new(timezone: 'UTC+00:00', success_count: 521, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-01:00', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-02:00', success_count: 2, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-02:30', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-03:00', success_count: 14, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-04:00', success_count: 1331, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-05:00', success_count: 1276, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-06:00', success_count: 522, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-07:00', success_count: 849, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-08:00', success_count: 299, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-09:00', success_count: 3, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-09:30', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-10:00', success_count: 15, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-11:00', success_count: 0, failure_count: 0),
    BatchRunData.new(timezone: 'UTC-12:00', success_count: 0, failure_count: 0)
  ].freeze
end
