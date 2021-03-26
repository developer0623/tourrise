# frozen_string_literal: true

class ProductVariant < ApplicationRecord
  belongs_to :product
  belongs_to :product_option
  belongs_to :product_option_value
  belongs_to :product_sku

  validates :product, :product_option, :product_option_value, :product_sku, presence: true
end
