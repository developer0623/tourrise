# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  subject(:booking) { build(:booking) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:product_sku) }
    it { is_expected.to validate_presence_of(:creator) }
  end

  context 'associations' do
    it { is_expected.to have_many(:booking_invoices) }
    it { is_expected.to have_many(:booking_offers) }

    it { is_expected.to have_many(:taggables) }
    it { is_expected.to have_many(:tags) }

    it { is_expected.to belong_to(:customer).optional }
    it { is_expected.to belong_to(:product_sku).required }
    it { is_expected.to belong_to(:creator).required }
    it { is_expected.to belong_to(:assignee).optional }
  end
end
