require 'oj'
require 'pusher'
require_relative 'vote_persistence'

class VoteHandler

  def process(message)
    value = Oj.load(message.value)

    # increment the vote
    current_value = VotePersistence.increment(value.fetch(:vote_for))

    # send the message to Pusher with the latest value
    Pusher.trigger('votes', 'vote', value.merge(absolute: current_value))
  end

end
