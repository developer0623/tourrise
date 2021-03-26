# frozen_string_literal: true

class Availability < ApplicationRecord
  belongs_to :inventory

  has_many :resource_sku_inventories
  has_many :resource_skus, through: :resource_sku_inventories

  has_many :booking_resource_sku_availabilities, dependent: :destroy
  has_many :booking_resource_skus, through: :booking_resource_sku_availabilities

  validates :quantity, presence: true, if: :quantity_type?
  validates :starts_on, :ends_on, :quantity, presence: true, if: :quantity_in_date_range_type?

  delegate :inventory_type, :quantity_type?, :quantity_in_date_range_type?, to: :inventory

  def allocated_quantity
    booking_resource_skus_with_occupation_configuration.count +
      participants_of_booking_resource_skus_without_occupation_configuration.count
  end

  def allocated_quantity_in_date_range(starts_on, ends_on)
    booking_resource_skus_with_occupation_configuration.in_date_range(starts_on, ends_on).count +
      participants_of_booking_resource_skus_without_occupation_configuration.in_date_range(starts_on, ends_on).count
  end

  private

  def booking_resource_skus_with_occupation_configuration
    booking_resource_skus
      .availability_reducing
      .where.not("resource_sku_snapshot LIKE ?", "%\"occupation_configuration_id\":null%")
  end

  def participants_of_booking_resource_skus_without_occupation_configuration
    booking_resource_skus
      .joins(:participants)
      .availability_reducing
      .where("resource_sku_snapshot LIKE ?", "%\"occupation_configuration_id\":null%")
  end
end
