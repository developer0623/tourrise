# frozen_string_literal: true

class ProductOptionValue < ApplicationRecord
  belongs_to :product_option, inverse_of: :product_option_values

  has_many :product_variants

  validates :value, :product_option, presence: true
end
