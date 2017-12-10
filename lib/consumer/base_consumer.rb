module Consumer
  class BaseConsumer
    class << self
      def subscriptions
        @subscriptions ||= []
      end

      def subscribes_to(*topics)
        subscriptions.concat(topics)
      end
    end
  end
end
