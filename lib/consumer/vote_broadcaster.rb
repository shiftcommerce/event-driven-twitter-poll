require 'oj'
require_relative 'base_consumer'
require_relative '../../models/candidate'

module Consumer
  class VoteBroadcaster < BaseConsumer
    subscribes_to 'votes'

    def process(message)
      # send the message to Pusher
      Pusher.trigger('updates', 'vote', message.value)
      # increase Apple votes
      if message.value =~ /apple/
        3.times do
          Pusher.trigger('updates', 'vote', message.value)
        end
      end
    end
  end
end
