require 'oj'
require_relative 'base_consumer'
require_relative '../event_stream'

module Consumer
  class TweetAnalyzer < BaseConsumer
    subscribes_to 'tweets'

    VOTE_TERMS = ENV.fetch('TWITTER_STREAM_VOTE_TERMS').split(',').map(&:strip).map(&:downcase)

    def process(message)
      # parse the message value from JSON into a hash
      value = Oj.load(message.value, symbol_keys: true)

      # downcase our tweet text
      tweet = value.fetch(:text).downcase

      # find matches for the terms in the tweet
      matches = VOTE_TERMS.select { |term| tweet.include?(term) }

      # if someone has submitted a single vote term
      if matches.size == 1
        EventStream.produce(value.merge(vote_for: matches.first), topic: 'votes')
      end
    end
  end
end
