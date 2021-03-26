# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::AssignResourceImages, type: :interactor do
  let(:images) { 'images' }
  let(:remove_images) { 'remove_image_ids' }
  let(:featured_image_id) { 'featured_image_id' }

  let(:resource) { instance_double(Resource) }
  let(:resource_image_service) { instance_double('ResourceImageService') }

  let(:call_params) do
    {
      resource: resource,
      images: images,
      remove_images: remove_images,
      featured_image_id: featured_image_id
    }
  end

  before do
    allow(ResourceImageService).to receive(:new) { resource_image_service }
    allow(resource_image_service).to receive(:add_images)
    allow(resource_image_service).to receive(:remove_images)
    allow(resource).to receive(:featured_image_id=)
  end


  it 'initalizes a resource image service' do
    described_class.call(call_params)

    expect(ResourceImageService).to have_received(:new).with(resource)
  end

  it 'adds the images to the resource' do
    described_class.call(call_params)

    expect(resource_image_service).to have_received(:add_images).with('images')
  end

  it 'it removes the images from the resource' do
    described_class.call(call_params)

    expect(resource_image_service).to have_received(:remove_images).with('remove_image_ids')
  end

  it 'assigns the featured image id' do
    described_class.call(call_params)

    expect(resource).to have_received(:featured_image_id=).with('featured_image_id')
  end

  context 'when no images context is provided' do
    let(:call_params) do
      {
        resource: resource
      }
    end

    it 'it does call add_images on the image service' do
      described_class.call(call_params)

      expect(resource_image_service).not_to have_received(:add_images)
    end
  end

  context 'when no remove_images context is provided' do
    let(:call_params) do
      {
        resource: resource
      }
    end

    it 'it does call remove_images on the image service' do
      described_class.call(call_params)

      expect(resource_image_service).not_to have_received(:remove_images)
    end
  end

  context 'when no remove_images context is provided' do
    let(:call_params) do
      {
        resource: resource
      }
    end

    it 'it does call set the featured image id' do
      described_class.call(call_params)

      expect(resource).not_to have_received(:featured_image_id=)
    end
  end

  context 'when no resource context is set' do
    let(:call_params) do
      {
        images: images,
        remove_images: remove_images,
        featured_image_id: featured_image_id
      }
    end

    it 'it is a failure' do
      context = described_class.call(call_params)

      expect(context.success?).to be(false)
    end

    it 'sets an error message' do
      context = described_class.call(call_params)

      expect(context.message).to eq('resource context missing')
    end
  end
end
