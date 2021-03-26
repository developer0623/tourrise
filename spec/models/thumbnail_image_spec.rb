require 'rails_helper'

RSpec.describe ThumbnailImage, type: :model do
  let(:image) { double(:image) }

  describe '.load' do
    before do
      allow(ThumbnailImage).to receive(:new).and_call_original
      allow(image).to receive(:variant)
      allow(image).to receive(:metadata) { { width: 10, height: 10 } }
    end

    it 'initializes a new image' do
      described_class.load(image)

      expect(described_class).to have_received(:new).with(image)
    end

    it 'processes the image' do
      described_class.load(image)

      expect(image).to have_received(:variant).with(
        crop: "10x10+0+0",
        resize: "64x64^"
      )
    end
  end
end
