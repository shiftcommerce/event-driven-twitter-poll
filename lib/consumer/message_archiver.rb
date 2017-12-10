require_relative 'base_consumer'
require_relative '../../models/archived_message'

module Consumer
  class MessageArchiver < BaseConsumer
    subscribes_to 'tweets', 'votes'

    def process(message)
      ArchivedMessage.create!({
        key:         message.key,
        value:       message.value,
        topic:       message.topic,
        partition:   message.partition,
        offset:      message.offset,
        create_time: message.create_time
      })
    end
  end
end
