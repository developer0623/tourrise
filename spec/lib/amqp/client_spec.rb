require 'rails_helper'

describe Amqp::Client do
  describe '.publish' do
    let(:connection) { double(:connection) }
    let(:channel) { double(:channel) }
    let(:exchange) { double(:exchange) }
    let(:data) { { foo: :bar } }
    let(:exchange_name) { 'exchange_1' }

    subject(:client) { Amqp::Client }

    before do
      allow(ENV).to receive(:fetch).with('CLOUDAMQP_URL') { 'amqp://test.cloud.amqp' }
      allow(Bunny).to receive(:new) { connection }
      allow(connection).to receive(:start) { connection }
      allow(connection).to receive(:close) { true }
      allow(connection).to receive(:create_channel) { channel }
      allow(channel).to receive(:fanout) { exchange }
      allow(exchange).to receive(:publish)
    end

    after do
      Amqp::Client.instance_variable_set('@connection', nil)
      Amqp::Client.instance_variable_set('@channel', nil)
    end

    it 'initializes a connection' do
      client.publish(exchange_name, data)

      expect(Bunny).to have_received(:new).with('amqp://test.cloud.amqp')
    end

    it 'starts the connection' do
      client.publish(exchange_name, data)

      expect(connection).to have_received(:start).with(no_args)
    end

    it 'creates a channel on the connection' do
      client.publish(exchange_name, data)

      expect(connection).to have_received(:create_channel).with(no_args)
    end

    it 'creates a fanout exchange on the channel' do
      client.publish(exchange_name, data)

      expect(channel).to have_received(:fanout).with('exchange_1')
    end

    it 'publishes the message on the exchange' do
      client.publish(exchange_name, data)

      expect(exchange).to have_received(:publish).with({ foo: :bar }.to_json)
    end
  end
end
