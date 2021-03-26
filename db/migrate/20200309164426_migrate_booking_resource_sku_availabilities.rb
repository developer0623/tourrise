class MigrateBookingResourceSkuAvailabilities < ActiveRecord::Migration[6.0]
  class Booking < ApplicationRecord
    def booked?
      self.aasm_state&.to_sym == :booked
    end
  end

  class BookingResourceSkuAvailability < ApplicationRecord
    belongs_to :booking_resource_sku
    belongs_to :availability

    belongs_to :blocked_by, class_name: "User", optional: true
    belongs_to :booked_by, class_name: "User", optional: true

    validates :blocked_by, presence: true, if: :blocked?
    validates :booked_by, presence: true, if: :booked?
    validates :booked_at, presence: true, if: -> { booking_resource_sku.booking.booked? }

    def blocked?
      blocked_at.present?
    end

    def booked?
      booked_at.present?
    end
  end

  class BookingResourceSku < ApplicationRecord
    belongs_to :booking
    belongs_to :resource_sku, optional: true
    has_one :booking_resource_sku_availability
    has_one :availability, through: :booking_resource_sku_availability

    scope :availability_reducing, lambda {
      left_joins(:booking_resource_sku_availability).where.not(booking_resource_sku_availabilities: { blocked_at: nil }).or(
        left_joins(:booking_resource_sku_availability).where.not(booking_resource_sku_availabilities: { booked_at: nil })
      )
    }

    scope :in_date_range, lambda { |starts_on, ends_on|
      starts_on_query = arel_table[:starts_on].lteq(ends_on)
      ends_on_query = arel_table[:ends_on].gteq(starts_on)

      where(starts_on_query.and(ends_on_query))
    }

    def with_date_range?
      starts_on.present? && ends_on.present?
    end
  end

  class ResourceSku < ApplicationRecord
    has_many :resource_sku_inventories, dependent: :destroy
    has_many :inventories, through: :resource_sku_inventories
    has_many :availabilities, through: :inventories
  end

  class Availability < ApplicationRecord
    belongs_to :inventory

    has_many :resource_sku_inventories
    has_many :resource_skus, through: :resource_sku_inventories

    has_many :booking_resource_sku_availabilities, dependent: :destroy
    has_many :booking_resource_skus, through: :booking_resource_sku_availabilities

    delegate :inventory_type, :quantity_type?, :quantity_in_date_range_type?, to: :inventory
  end

  class Inventory < ApplicationRecord
    has_many :resource_sku_inventories, dependent: :destroy
    has_many :resource_skus, through: :resource_sku_inventories

    has_many :availabilities
    has_many :booking_resource_skus, through: :availabilities

    scope :with_quantity, -> { where(inventory_type: :quantity) }
    scope :with_quantity_in_date_range, -> { where(inventory_type: :quantity_in_date_range) }

    def quantity_type?
      inventory_type.to_sym == :quantity
    end

    def quantity_in_date_range_type?
      inventory_type.to_sym == :quantity_in_date_range
    end
  end

  class AvailabilityService
    attr_reader :availability

    def initialize(availability)
      @availability = availability
    end

    def available_for_quantity?(requested_quantity)
      raise 'invalid method. try the other one. lel' if availability.quantity_in_date_range_type?

      allocatable_quantity = availability.quantity - availability.booking_resource_skus.availability_reducing.count

      allocatable_quantity >= requested_quantity
    end

    def available_for_quantity_in_date_range?(requested_quantity, starts_on, ends_on)
      allocatable_quantity = availability.quantity - availability.booking_resource_skus.in_date_range(starts_on, ends_on).availability_reducing.count

      allocatable_quantity >= requested_quantity
    end
  end

  def up
    BookingResourceSku.all.each do |booking_resource_sku|
      next unless booking_resource_sku.resource_sku.present?
      next if booking_resource_sku.availability.present?

      resource_sku = booking_resource_sku.resource_sku
      availabilities = resource_sku.availabilities
      booking = booking_resource_sku.booking

      next unless availabilities.any?

      booking_resource_sku.availability = find_availability(booking_resource_sku, availabilities)

      BookingResourceSkus::CommitBookingResourceSku.call!(booking_resource_sku: booking_resource_sku, user_id: booking.assignee_id || User.first.id) if booking.booked?
    end
  end

  def down
  end

  private

  def find_availability(booking_resource_sku, availabilities)
    availabilities.find do |availability|
      service = AvailabilityService.new(availability)

      if availability.quantity_type?
        return availability if service.available_for_quantity?(booking_resource_sku.quantity)
        next
      end

      if availability.quantity_in_date_range_type?
        return availability if service.available_for_quantity_in_date_range?(booking_resource_sku.quantity, booking_resource_sku.starts_on, booking_resource_sku.ends_on)
        next
      end

      availability
    end
  end
end
