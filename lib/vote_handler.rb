require 'dotenv/load'
require 'oj'
require 'pusher'

class VoteProcessor
  VOTES = Hash.new(0)

  PUSHER_CLIENT = Pusher::Client.new(
    app_id: ENV.fetch('PUSHER_APP_ID'),
    key: ENV.fetch('PUSHER_APP_KEY'),
    secret: ENV.fetch('PUSHER_APP_SECRET'),
    cluster: 'eu',
    encrypted: true
  )

  def process(message)
    value = Oj.load(message.value)

    # add the vote
    current_value = VOTES[value.fetch(:vote_for)] += 1

    # send the message to Pusher with the latest value
    PUSHER_CLIENT.trigger('votes', 'vote', value.merge(absolute: current_value))
  end
end
