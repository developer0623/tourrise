# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::UpdateResource, type: :interactor do
  let(:resource_params) do
    {
      images: images,
      remove_images: remove_images,
      featured_image_id: featured_image_id
    }
  end

  let(:resource_double) { instance_double(Resource) }
  let(:images) { 'images' }
  let(:remove_images) { 'remove_images' }
  let(:featured_image_id) { 'featured_image_id' }

  describe ".call" do
    before do
      allow(Resources::LoadResource).to receive(:call!) { :success }
      allow(Resources::AssignResourceAttributes).to receive(:call!) { :success }
      allow(Resources::AssignResourceTags).to receive(:call!) { :success }
      allow(Resources::AssignResourceImages).to receive(:call!) { :success }
      allow(Resources::SaveResource).to receive(:call!) { :success }
      allow(Resources::PublishResourceUpdatedEvents).to receive(:call!) { :success }
    end

    it 'organizes the interactors in the correct order' do
      expect(described_class.organized).to eq(
        [
          Resources::LoadResource,
          Resources::AssignResourceAttributes,
          Resources::AssignResourceTags,
          Resources::AssignResourceImages,
          Resources::SaveResource,
          Resources::PublishResourceUpdatedEvents
        ]
      )
    end

    it 'sets the images context' do
      context = described_class.call(params: resource_params)

      expect(context.images).to eq(images)
    end

    it 'sets the remove_images context' do
      context = described_class.call(params: resource_params)

      expect(context.remove_images).to eq(remove_images)
    end

    it 'sets the featured_image_id context' do
      context = described_class.call(params: resource_params)

      expect(context.featured_image_id).to eq(featured_image_id)
    end

    it 'loads the resource' do
      context = described_class.call(params: resource_params)

      expect(Resources::LoadResource).to have_received(:call!).with(context)
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

    it 'calls the PublishResourceUpdatedEvents interactor' do
      context = described_class.call(params: resource_params)

      expect(Resources::PublishResourceUpdatedEvents).to have_received(:call!).with(context)
    end
  end
end
