# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::CreateResource, type: :interactor do
  let(:resource_params) do
    {
      images: images,
      featured_image_id: featured_image_id
    }
  end

  let(:resource_double) { instance_double(Resource) }
  let(:images) { 'images' }
  let(:featured_image_id) { 'featured_image_id' }

  describe ".call" do
    before do
      allow(Resource).to receive(:new) { resource_double }
      allow(Resources::AssignResourceAttributes).to receive(:call!) { :success }
      allow(Resources::AssignResourceTags).to receive(:call!) { :success }
      allow(Resources::AssignResourceImages).to receive(:call!) { :success }
      allow(Resources::SaveResource).to receive(:call!) { :success }
      allow(Resources::PublishResourceCreatedEvents).to receive(:call!) { :success }
    end

    it 'organizes the interactors in the correct order' do
      expect(described_class.organized).to eq(
        [
          Resources::AssignResourceAttributes,
          Resources::AssignResourceTags,
          Resources::AssignResourceImages,
          Resources::SaveResource,
          Resources::PublishResourceCreatedEvents
        ]
      )
    end

    it 'sets a new resource context' do
      context = described_class.call(params: resource_params)

      expect(context.resource).to eq(resource_double)
    end

    it 'sets the images context' do
      context = described_class.call(params: resource_params)

      expect(context.images).to eq(images)
    end

    it 'sets the featured_image_id context' do
      context = described_class.call(params: resource_params)

      expect(context.featured_image_id).to eq(featured_image_id)
    end

    it 'calls the AssignResourceAttributes interactor' do
      context = described_class.call(params: resource_params)

      expect(Resources::AssignResourceAttributes).to have_received(:call!).with(context)
    end

    it 'calls the AssignResourceImages interactor' do
      context = described_class.call(params: resource_params)

      expect(Resources::AssignResourceImages).to have_received(:call!).with(context)
    end

    it 'calls the SaveResource interactor' do
      context = described_class.call(params: resource_params)

      expect(Resources::SaveResource).to have_received(:call!).with(context)
    end

    it 'calls the PublishResourceCreatedEvents interactor' do
      context = described_class.call(params: resource_params)

      expect(Resources::PublishResourceCreatedEvents).to have_received(:call!).with(context)
    end
  end
end
