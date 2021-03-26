# frozen_string_literal: true

class SeasonalProductSku < ApplicationRecord
  attr_accessor :enabled

  belongs_to :season
  belongs_to :product_sku
end
