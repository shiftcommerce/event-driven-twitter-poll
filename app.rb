require 'sinatra'
require 'rack/ssl'
require 'pusher'
require_relative 'lib/vote_persistence'

configure :development do
  require 'dotenv/load'
end

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
  terms = ENV.fetch('TWITTER_STREAM_VOTE_TERMS').split(',').map(&:strip).each_with_object({}) { |term, hash|
    hash[term] = VotePersistence.read(term)
  }

  erb :index, locals: {
    vote_terms: terms,
    pusher_key: Pusher.key
  }
end
