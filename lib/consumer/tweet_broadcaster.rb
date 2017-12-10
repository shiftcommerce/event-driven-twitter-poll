require 'oj'
require 'pusher'
require_relative 'base_consumer'

module Consumer
  class TweetBroadcaster < BaseConsumer
    subscribes_to 'tweets'

    def process(message)
      # send the message to Pusher
      Pusher.trigger('updates', 'tweet', message.value)
    end
  end
end
