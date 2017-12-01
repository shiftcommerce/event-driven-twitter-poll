require 'dotenv/load'
require 'sinatra'
require 'rack/ssl'

configure :production do
  # enforce HTTPS in production
  use Rack::SSL

  # cache static files for a long time
  set :static_cache_control, [:public, max_age: 60 * 60 * 24]
end

configure do
  # use Puma, a concurrent Ruby web server
  set :server, :puma
end

get '/' do
  erb :index
end
