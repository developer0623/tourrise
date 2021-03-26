# frozen_string_literal: true

class ResourceType < ApplicationRecord
  has_many :resources, dependent: :nullify

  validates :label, :handle, presence: true
  validates :handle, uniqueness: true

  def self.accommodation
    ResourceType.find_by(handle: :accommodation)
  end

  def self.rentalbike
    ResourceType.find_by(handle: :rentalbike)
  end

  def self.rentalcar
    ResourceType.find_by(handle: :rentalcar)
  end

  def self.flight
    ResourceType.find_by(handle: :flight)
  end

  def self.transfer
    ResourceType.find_by(handle: :transfer)
  end

  def self.island_hopping
    ResourceType.find_by(handle: :island_hopping)
  end

  def self.training_package
    ResourceType.find_by(handle: :training_package)
  end

  def self.basic
    ResourceType.find_by(handle: :basic)
  end

  def self.discount
    ResourceType.find_by(handle: :discount)
  end

  def with_date_range?
    booking_attributes
      .includes(:booking_attributes)
      .where(booking_attributes: { handle: %i[starts_on ends_on] }).count == 2
  end
end
