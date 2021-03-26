# frozen_string_literal: true

module Easybill
  module Amqp
    class Listener
      THREAD_LIMIT = 255

      def initialize(queue_subscriptions)
        @queue_subscriptions = queue_subscriptions
      end

      def start
        trap("TERM") do
          with_thread { say "Exiting..." }
          exit
        end

        trap("INT") do
          with_thread { say "Exiting..." }
          exit
        end

        Easybill::Amqp::Client.create_connection

        threads = @queue_subscriptions.map do |queue_subscription|
          with_thread { Easybill::Amqp::Client.subscribe(*queue_subscription) }
        end

        threads.each(&:join)
      end

      private

      def with_thread
        say "Thread count: #{thread_count}"
        raise "Too many threads exception. Raise your limits!" if thread_count >= THREAD_LIMIT

        thread = Thread.new do
          yield
        end
        thread.abort_on_exception = true
        thread
      end

      def say(text)
        Rails.logger.info(text)
      end

      def thread_count
        Thread.list.count
      end
    end
  end
end
