require 'oj'
require 'pusher'

class VoteProcessor
  VOTES = Hash.new(0)

  def process(message)
    value = Oj.load(message.value)

    # add the vote
    current_value = VOTES[value.fetch(:vote_for)] += 1

    # send the message to Pusher with the latest value
    Pusher.trigger('votes', 'vote', value.merge(absolute: current_value))
  end
end
