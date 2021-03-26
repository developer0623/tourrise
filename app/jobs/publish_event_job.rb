# frozen_string_literal: true

class PublishEventJob < ApplicationJob
  def perform(exchange, data)
    Amqp::Client.publish(exchange, data)
  end
end
