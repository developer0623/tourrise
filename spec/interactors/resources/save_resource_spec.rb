# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::SaveResource, type: :interactor do
  let(:resource) { instance_double(Resource) }

  describe '.call' do
    before do
      allow(resource).to receive(:save) { true }
    end

    it 'is a success' do
      context = described_class.call(resource: resource)

      expect(context.success?).to be(true)
    end

    context 'when saving fails' do
      let(:errors) { double(:errors) }

      before do
        allow(resource).to receive(:save) { false }
        allow(resource).to receive(:errors) { errors }
        allow(errors).to receive(:full_messages) { 'error_messages' }
      end

      it 'it is a failure' do
        context = described_class.call(resource: resource)

        expect(context.success?).to be(false)
      end

      it 'sets an error message' do
        context = described_class.call(resource: resource)

        expect(context.message).to eq('error_messages')
      end
    end

    context 'when a record not unique error is being raised' do
      before do
        allow(resource).to receive(:save).and_raise(ActiveRecord::RecordNotUnique)
      end

      it 'it is a failure' do
        context = described_class.call

        expect(context.success?).to be(false)
      end

      it 'sets an error message' do
        context = described_class.call(resource: resource)

        expect(context.message).to eq('resource sku already exists')
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

  describe '.rollback' do
    before do
      allow(resource).to receive(:destroy)
    end

    context 'when the resource has just been created' do
      it 'destroys the resource' do
        described_class.new(resource: resource, destroy_on_rollback: true).rollback

        expect(resource).to have_received(:destroy).with(no_args)
      end
    end

    context 'when the resource only received an update' do
      it 'does not destroy the resource' do
        described_class.new(resource: resource).rollback

        expect(resource).not_to have_received(:destroy)
      end
    end
  end
end
