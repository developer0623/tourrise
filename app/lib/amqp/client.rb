# frozen_string_literal: true

module Amqp
  class Client
    def self.connection
      return @connection if @connection.present?

      @connection = Bunny.new(ENV.fetch("CLOUDAMQP_URL"))
      @connection.start
    end

    def self.channel
      @channel ||= connection.create_channel
    rescue RuntimeError
      @connection.start
    end

    def self.publish(exchange_name, payload)
      exchange = channel.fanout(exchange_name)
      exchange.publish(payload.to_json)
      Rails.logger.info("Publishing #{payload} to #{exchange_name} succeeded.")
    rescue Bunny::TCPConnectionFailed
      Rails.logger.error("Publishing #{payload} to #{exchange_name} failed.")
      raise unless Rails.env.development? || Rails.env.test?
    end
  end
end
