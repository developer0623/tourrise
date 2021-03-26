require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { build(:product) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'associations' do
    it { is_expected.to have_many(:seasons) }
  end
end
