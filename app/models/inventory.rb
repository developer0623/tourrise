# frozen_string_literal: true

class Inventory < ApplicationRecord
  VALID_TYPES = %i[quantity quantity_in_date_range].freeze

  has_many :resource_sku_inventories, dependent: :destroy
  has_many :resource_skus, through: :resource_sku_inventories

  has_many :availabilities
  has_many :booking_resource_skus, through: :availabilities

  accepts_nested_attributes_for :availabilities, allow_destroy: true

  validates :name, presence: true
  validates :inventory_type, inclusion: { in: VALID_TYPES.map(&:to_s) }

  scope :with_quantity, -> { where(inventory_type: :quantity) }
  scope :with_quantity_in_date_range, -> { where(inventory_type: :quantity_in_date_range) }

  def quantity_type?
    inventory_type.to_sym == :quantity
  end

  def quantity_in_date_range_type?
    inventory_type.to_sym == :quantity_in_date_range
  end
end
