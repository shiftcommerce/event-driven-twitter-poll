require 'dotenv/load'
require 'sinatra'
require 'rack/ssl'
require 'pusher'

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
  erb :index, locals: {
    vote_terms: ENV.fetch('TWITTER_STREAM_VOTE_TERMS').split(',').map(&:strip),
    pusher_key: Pusher.key
  }
end
