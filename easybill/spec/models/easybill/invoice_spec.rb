require 'rails_helper'

describe Easybill::Invoice, type: :model do
  subject(:booking) { described_class.new external_id: '123' }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:external_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:booking_invoice) }
  end

  describe '#canceled?' do
    it 'returns true when canceled_at is set' do
      subject.canceled_at = Time.zone.now

      expect(subject.canceled?).to be(true)
    end

    it 'returns false when canceled_at is set' do
      subject.canceled_at = nil

      expect(subject.canceled?).to be(false)
    end
  end

  describe '#cancel!' do
    it 'sets canceled_at to the current time' do
      expect(subject.canceled_at).to be(nil)

      subject.cancel!

      expect(subject.canceled_at).to be_present
    end
  end
end

