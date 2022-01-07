# frozen_string_literal: true

require 'sinatra/base'

# Error Endpoints
class Web < Sinatra::Base
  configure do
    disable :show_exceptions
  end

  error 404 do
    slim :'errors/404'
  end

  error do
    slim :'errors/500'
  end

  get('/errors/500') { slim :'errors/500' }
  get('/errors/404') { slim :'errors/404' }
  get('/errors/br_in_the_past') { slim :'/errors/br_in_the_past' }
  get('/errors/br_unloadable') { slim :'/errors/br_unloadable' }
end
