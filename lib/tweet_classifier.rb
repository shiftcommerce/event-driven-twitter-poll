require 'oj'
require_relative 'fake_kafka_message'
require_relative 'vote_handler'

class TweetClassifier
  VOTE_ITEM_1 = /(apple)/i
  VOTE_ITEM_2 = /(android)/i

  def process(message)
    # parse the message value from JSON into a hash
    value = Oj.load(message.value)

    # test if someone's trying to vote for both
    if value.fetch(:text) =~ VOTE_ITEM_1 && value.fetch(:text) =~ VOTE_ITEM_2
      # no-op: don't try to get clever with me!

    # is someone voting for just item 1?
    elsif value.fetch(:text) =~ VOTE_ITEM_1
      VoteProcessor.new.process FakeKafkaMessage.new(Oj.dump({
        tweet_id: value.fetch(:tweet_id),
        screen_name: value.fetch(:screen_name),
        vote_for: $1
      }))

    # is someone voting for just item 2?
    elsif value.fetch(:text) =~ VOTE_ITEM_2
      VoteProcessor.new.process FakeKafkaMessage.new(Oj.dump({
        tweet_id: value.fetch(:tweet_id),
        screen_name: value.fetch(:screen_name),
        vote_for: $1
      }))

    # does the message not include a vote at all?
    else
      # no-op
    end
  rescue KeyError => ex
    puts "Message value: #{value.inspect}"
    raise ex
  end
end
