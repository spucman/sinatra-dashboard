# frozen_string_literal: true

require 'sinatra/base'
require 'rack/contrib'
require 'json'
require_relative 'rest/basic'
require_relative 'rest/batch_run'
require_relative 'rest/user'

# Entry Point for all rest requests
class Rest < Sinatra::Base
end
