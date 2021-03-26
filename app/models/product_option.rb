# frozen_string_literal: true

class ProductOption < ApplicationRecord
  belongs_to :product

  has_many :product_option_values, inverse_of: :product_option
  has_many :product_variants

  validates :name, :product_option_values, presence: true
  validates_associated :product_option_values
end
