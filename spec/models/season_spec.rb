require 'rails_helper'

RSpec.describe Season, type: :model do
  subject(:season) { build(:season) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to have_many(:product_skus) }
  end

  describe "#published?" do
    context "when published at is set" do
      subject(:season) { build(:season, published_at: 1.day.ago).published? }

      it { is_expected.to be(true) }
    end

    context "when published_at is missing" do
      subject(:season) { build(:season, published_at: nil).published? }

      it { is_expected.to be(false) }
    end
  end
end
