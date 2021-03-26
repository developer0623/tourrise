# frozen_string_literal: true

class Season < ApplicationRecord
  belongs_to :product

  has_many :seasonal_product_skus
  accepts_nested_attributes_for :seasonal_product_skus, allow_destroy: true

  has_many :product_skus, through: :seasonal_product_skus
  accepts_nested_attributes_for :product_skus

  validates :name, presence: true, uniqueness: { scope: :product, case_sensitive: false }

  scope :published, -> { where.not(published_at: nil) }

  def published?
    published_at.present?
  end
end
