require 'rails_helper'

describe Easybill::Offer, type: :model do
  subject(:booking) { described_class.new }

  context 'validations' do
    it { is_expected.to validate_presence_of(:external_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:booking_offer) }
  end
end
