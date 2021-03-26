require 'rails_helper'

RSpec.describe ConsecutiveDaysRange, type: :model do
  it { is_expected.to belong_to(:resource_sku_pricing) }

  it { is_expected.to validate_numericality_of(:from).only_integer }
  it { is_expected.to validate_numericality_of(:to).only_integer }

  describe 'validations' do
    let(:consecutive_days_range) { build(:consecutive_days_range, attributes) }

    describe 'limits' do
      let(:attributes) { { from: nil, to: nil } }
      let(:error_message) { "From or to should be present in attributes" }

      it do
        expect(consecutive_days_range.valid?).to be_falsey
        expect(consecutive_days_range.errors.full_messages).to include error_message
      end
    end

    describe ":to can't be greater than :from" do
      let(:attributes) { { from: 5, to: 3 } }
      let(:error_message) { ":to should be greater than :from" }

      it do
        expect(consecutive_days_range.valid?).to be_falsey
        expect(consecutive_days_range.errors.full_messages).to include error_message
      end
    end
  end
end
