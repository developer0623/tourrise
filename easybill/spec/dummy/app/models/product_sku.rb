# frozen_string_literal: true

class ProductSku < ApplicationRecord
  translates :name, :description, fallbacks_for_empty_translations: true
  include GlobalizeScope

  belongs_to :product, inverse_of: :product_skus
  belongs_to :financial_account, optional: true
  belongs_to :cost_center, optional: true

  has_many :bookings, dependent: :nullify

  has_one :product_sku_booking_configuration, dependent: :destroy
  accepts_nested_attributes_for :product_sku_booking_configuration

  validates :name, :handle, :product, presence: true
  validates :handle, uniqueness: { case_sensitive: false }

  delegate :resources, to: :product
  delegate :published?, to: :product

  scope :published, -> { joins(:product).merge(Product.published) }

  def financial_account
    super.presence || product.financial_account
  end

  def cost_center
    super.presence || product.cost_center
  end
end
