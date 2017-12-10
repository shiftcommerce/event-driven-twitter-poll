require 'dotenv/load' unless 'production' == ENV['RACK_ENV']
require 'sinatra'
require 'rack/ssl'
require 'pusher'
require_relative 'models/candidate'

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
  candidate_keys = ENV.fetch('TWITTER_STREAM_VOTE_TERMS').split(',')

  erb :index, locals: {
    term: ENV.fetch('TWITTER_STREAM_SEARCH_TERM'),
    candidate_keys: candidate_keys,
    candidates: Candidate.where(key: candidate_keys.map(&:downcase)),
    pusher_key: Pusher.key
  }
end
