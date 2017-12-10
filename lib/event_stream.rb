require 'oj'
require 'ruby-kafka'
require_relative 'consumer/message_archiver'
require_relative 'consumer/tweet_analyzer'
require_relative 'consumer/tweet_broadcaster'
require_relative 'consumer/vote_broadcaster'
require_relative 'consumer/vote_persister'

module EventStream
  def self.consumers
    @consumers ||= [
      Consumer::MessageArchiver,
      Consumer::TweetAnalyzer,
      Consumer::TweetBroadcaster,
      Consumer::VoteBroadcaster,
      Consumer::VotePersister
    ]
  end

  def self.exclude(*excluded_consumers)
    @consumers = self.consumers - excluded_consumers
  end

  def self.replaying?
    !!@replaying
  end

  def self.replaying=(value)
    @replaying = value
  end

  def self.produce(payload, topic:)
    # skip production if replaying
    return if replaying?
    # build our JSON
    value = Oj.dump(payload, mode: :compat)
    # build our message
    message = Kafka::FetchedMessage.new(value: value, topic: topic, partition: 1, offset: Time.now.to_i)
    # execute the message
    execute(message)
  end

  def self.execute(message)
    consumers.select { |consumer|
      consumer.subscriptions.include?(message.topic)
    }.each { |consumer|
      puts "Calling consumer #{consumer.name} with message: #{message}"
      consumer.new.process(message)
    }
  end
end
