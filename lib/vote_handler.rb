require 'oj'
require 'pusher'

class VoteProcessor

  def process(message)
    value = Oj.load(message.value)

    # increment the vote
    current_vote = VotePersistence.increment(value.fetch(:vote_for))

    # send the message to Pusher with the latest value
    Pusher.trigger('votes', 'vote', value.merge(absolute: current_value))
  end

end
