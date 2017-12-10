unless 'production' == ENV['RACK_ENV']
  require 'dotenv/load'
end

require 'twitter'
require 'oj'
require_relative '../lib/event_stream'

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
  config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
  config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
  config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
end

client.filter(track: ENV.fetch('TWITTER_STREAM_SEARCH_TERM')) do |object|

  if object.is_a?(Twitter::Tweet)
    EventStream.produce({
      tweet_id:    object.id,
      screen_name: object.user.screen_name,
      text:        object.text
    }, topic: 'tweets')
  end

end
