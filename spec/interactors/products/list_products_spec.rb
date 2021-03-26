# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Products::ListProducts do
  describe '.call' do
    it 'returns an array of all products' do
      result = described_class.call

      expect(result.products).to eq([])
    end
  end
end
