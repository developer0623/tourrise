# frozen_string_literal: true

require 'rails_helper'

describe Easybill::CustomerSync do
  describe '.last_sync_at' do
    before do
      described_class.create(last_sync_at: DateTime.new(2010, 10, 10))
      described_class.create(last_sync_at: DateTime.new(2017, 10, 10))
    end

    it 'returns the youngest timestamp' do
      last_synced_at = described_class.last_sync_at
      expect(last_synced_at.year).to eq(2017)
    end
  end
end
