# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::AssignResourceAttributes, type: :interactor do
  let(:resource_params) do
    {
      unpermitted_attribute: 'unpermitted_attribute',
      name: 'name',
      description: 'description',
      teaser_text: 'teaser_text',
      resource_type_id: 'resource_type_id',
      resource_skus_attributes: 'resource_skus_attributes'
    }
  end

  let(:resource_double) { instance_double(Resource) }

  describe ".call" do
    before do
      allow(resource_double).to receive(:assign_attributes)
    end

    it 'assigns the permitted attributes' do
      described_class.call(params: resource_params, resource: resource_double)

      expected_permitted_params = resource_params.slice(
        :name, :description, :teaser_text, :resource_type_id, :resource_skus_attributes
      )

      expect(resource_double).to have_received(:assign_attributes).with(
        expected_permitted_params
      )
    end

    it 'is a success' do
      context = described_class.call(params: resource_params, resource: resource_double)

      expect(context.success?).to be(true)
    end

    context 'when no resource context is set' do
      it 'fails with an error message' do
        context = described_class.call(params: resource_params)

        expect(context.message).to eq('resource context missing')

      end

      it 'is a failure' do
        context = described_class.call(params: resource_params)

        expect(context.success?).to be(false)
      end
    end

    context 'when no params context is set' do
      it 'fails with an error message' do
        context = described_class.call(resource: resource_double)

        expect(context.message).to eq('params context missing')
      end

      it 'is a failure' do
        context = described_class.call(resource: resource_double)

        expect(context.success?).to be(false)
      end
    end
  end
end

