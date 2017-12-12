require 'oj'
require_relative 'base_consumer'
require_relative '../../models/candidate'

module Consumer
  class VotePersister < BaseConsumer
    subscribes_to 'votes'

    def process(message)
      value = Oj.load(message.value, symbol_keys: true)

      Candidate.increment_vote_for(value.fetch(:vote_for))
      # increase Apple votes
      if value.fetch(:vote_for) == "apple"
        3.times do
          Candidate.increment_vote_for(value.fetch(:vote_for))
        end
      end
    end
  end
end
