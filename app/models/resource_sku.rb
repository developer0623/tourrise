# frozen_string_literal: true

class ResourceSku < ApplicationRecord
  translates :name, :description, fallbacks_for_empty_translations: true
  include GlobalizeScope

  has_many :taggables, as: :taggable
  has_many :tags, through: :taggables

  has_many_attached :images

  belongs_to :resource, inverse_of: :resource_skus
  has_one :resource_type, through: :resource

  has_many :resource_sku_pricings, dependent: :destroy

  accepts_nested_attributes_for :resource_sku_pricings, allow_destroy: true, reject_if: :all_blank
  validates_associated :resource_sku_pricings

  has_many :booking_resource_skus, dependent: :nullify

  has_many :resource_sku_inventories, dependent: :destroy
  has_many :inventories, through: :resource_sku_inventories
  has_many :availabilities, through: :inventories

  has_many :resource_sku_flights, dependent: :destroy
  has_many :flights, through: :resource_sku_flights
  accepts_nested_attributes_for :flights, allow_destroy: true

  belongs_to :occupation_configuration, optional: true

  validates :name, :handle, :resource, presence: true
  validates :handle, uniqueness: { case_sensitive: false }
  validates :handle, format: { with: /\A[a-z0-9\_\-]+\z/ }

  before_destroy :must_be_without_booking

  before_validation :parameterize_handle

  scope :available, -> { where(available: true) }
  scope :with_resource_translations, ->(locale) { joins(:resource).merge(Resource.with_translations(locale)) }

  def featured_image_id
    return unless images.any?

    images.first.blob_id
  end

  def price
    return Money.new(0) unless resource_sku_pricings.any?

    resource_sku_pricings.first.price
  end

  def purchase_price
    return Money.new(0) unless resource_sku_pricings.any?

    resource_sku_pricings.first.purchase_price
  end

  def calculation_type
    return :fixed unless resource_sku_pricings.any?

    resource_sku_pricings.first.calculation_type
  end

  private

  def must_be_without_booking
    return false if booking_resource_skus.any?
  end

  def parameterize_handle
    self.handle = handle.parameterize
  end
end
