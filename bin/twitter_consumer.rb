require 'dotenv/load'
require 'twitter'
require 'oj'
require_relative '../lib/tweet_handler'

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
  config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
  config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
  config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
end

client.filter(track: ENV.fetch('TWITTER_STREAM_SEARCH_TERM')) do |object|
  if object.is_a?(Twitter::Tweet)
    TweetHandler.call(object)
  end
end
