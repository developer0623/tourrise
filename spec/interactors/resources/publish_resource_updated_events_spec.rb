# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::PublishResourceUpdatedEvents, type: :interactor do
  let(:resource) { instance_double(Resource) }
  let(:resource_sku) { instance_double(ResourceSku) }
  let(:resource_skus) { [resource_sku] }

  before do
    allow(resource).to receive(:resource_skus) { resource_skus }
    allow(resource_sku).to receive(:id_previously_changed?) { false }
    allow(ResourceSkus::PublishResourceSkuUpdatedEvent).to receive(:call!) { :success }
    allow(ResourceSkus::PublishResourceSkuCreatedEvent).to receive(:call!) { :success }
    allow(PublishEventJob).to receive(:perform_later)
  end

  it 'publishes the resource created event' do
    described_class.call(resource: resource)

    expect(PublishEventJob).to have_received(:perform_later).with('resources.updated', resource)
  end

  context 'when it is an existing sku' do
    it 'calls the resource sku updated event publisher' do
      described_class.call(resource: resource)

      expect(ResourceSkus::PublishResourceSkuUpdatedEvent).to have_received(:call!).with(resource_sku: resource_sku)
    end
  end

  context 'when it is a new sku' do
    before do
      allow(resource_sku).to receive(:id_previously_changed?) { true }
    end

    it 'calls the resource sku updated event publisher' do
      described_class.call(resource: resource)

      expect(ResourceSkus::PublishResourceSkuCreatedEvent).to have_received(:call!).with(resource_sku: resource_sku)
    end
  end

  context 'when no resource context is set' do
    it 'it is a failure' do
      context = described_class.call

      expect(context.success?).to be(false)
    end

    it 'sets an error message' do
      context = described_class.call

      expect(context.message).to eq('resource context missing')
    end
  end
end
