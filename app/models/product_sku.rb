# frozen_string_literal: true

class ProductSku < ApplicationRecord
  translates :name, :description, fallbacks_for_empty_translations: true
  include GlobalizeScope

  belongs_to :product, inverse_of: :product_skus
  belongs_to :financial_account, optional: true
  belongs_to :cost_center, optional: true

  has_many :bookings, dependent: :nullify

  has_many :seasonal_product_skus
  has_many :seasons, through: :seasonal_product_skus

  has_one :product_sku_booking_configuration, dependent: :destroy
  accepts_nested_attributes_for :product_sku_booking_configuration

  validates :name, :handle, :product, presence: true
  validates :handle, uniqueness: { case_sensitive: false }

  delegate :resources, :published?, :current_season, to: :product

  scope :published, -> { joins(:seasons).merge(Season.published) }

  def financial_account
    super.presence || product.financial_account
  end

  def cost_center
    super.presence || product.cost_center
  end

  def current_active_season
    seasons.published.where(id: product.current_season_id).first
  end

  def current_active_seasonal_product_sku
    return unless current_active_season.present?

    SeasonalProductSku.where(product_sku_id: id, season_id: current_active_season.id).first
  end
end
