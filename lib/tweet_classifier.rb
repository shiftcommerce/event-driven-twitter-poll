require 'oj'
require_relative 'fake_kafka_message'
require_relative 'vote_handler'

class TweetClassifier
  VOTE_TERMS = ENV.fetch('TWITTER_STREAM_VOTE_TERMS').split(',').map(&:strip).map(&:downcase)

  def process(message)
    # parse the message value from JSON into a hash
    value = Oj.load(message.value)

    # downcase our tweet text
    tweet = value.fetch(:text).downcase

    # find matches for the terms in the tweet
    matches = VOTE_TERMS.select { |term| tweet.include?(term) }

    # if someone has submitted a single vote term
    if matches.size == 1
      # process their vote
      json = Oj.dump(value.merge(vote_for: matches.first))
      VoteProcessor.new.process FakeKafkaMessage.new(json)
    end
  end
end
