require 'rails_helper'

RSpec.describe SeasonalProductSku, type: :model do
  subject(:seasonal_product_sku) { build(:seasonal_product_sku) }

  describe "associatons" do
    it { is_expected.to belong_to(:season) }
    it { is_expected.to belong_to(:product_sku) }
  end
end
