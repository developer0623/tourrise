# frozen_string_literal: true

module Easybill
  module Amqp
    class Client
      class << self
        def subscribe(exchange, queue_name, handler)
          Rails.logger.info "AMQP: start listening on #{exchange}:#{queue_name} with #{handler}"
          queue(exchange, queue_name).subscribe(block: true) do |_delivery_info, _metadata, payload|
            handle_payload(handler, payload)
          end
        end

        def create_connection
          @connection = Bunny.new(ENV.fetch("CLOUDAMQP_URL"))
          @connection.start
        end

        private

        def handle_payload(handler, payload)
          payload = JSON.parse(payload)

          handler.handle(payload)
          true
        rescue StandardError => e
          Rails.logger.error "Error processing: #{e.message}"
          Rails.logger.error e.backtrace
          false
        end

        def queue(exchange, queue_name)
          channel = @connection.create_channel

          exchange = channel.fanout(exchange)
          channel.queue(queue_name).bind(exchange)
        end
      end
    end
  end
end
