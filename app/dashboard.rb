# frozen_string_literal: true

require 'sinatra/base'
require_relative 'web/controllers/web'
require_relative 'web/controllers/rest'
require_relative 'web/controllers/assets'
require_relative 'web/controllers/webauth'
require_relative 'web/controllers/errors'

# Root of the Admin Dashboard
class AdminDashboard < Sinatra::Base
  use Web
  use Rest

  get('/healthz') { 'Ok!' }
end
