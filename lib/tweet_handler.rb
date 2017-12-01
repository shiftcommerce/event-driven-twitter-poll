require 'oj'
require_relative 'tweet_classifier'
require_relative 'fake_kafka_message'

module TweetHandler
  def self.call(tweet)
    json = Oj.dump({
      tweet_id:    tweet.id,
      screen_name: tweet.user.screen_name,
      text:        tweet.text
    })
    TweetClassifier.new.process FakeKafkaMessage.new(json)
  end
end
