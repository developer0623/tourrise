# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :product_sku
  belongs_to :assignee, optional: true
  has_one :product, through: :product_sku

  has_many :booking_resource_skus
  has_many :booking_resource_sku_groups
  has_many :resources, through: :booking_resource_skus
  has_many :flights, through: :booking_resource_skus

  def participants; end
end
