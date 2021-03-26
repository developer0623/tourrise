class AddColumnBookedAtToBookingResourceSkusAvailabilities < ActiveRecord::Migration[6.0]
  class Booking < ApplicationRecord
    has_many :booking_resource_skus
    belongs_to :assignee, class_name: 'User', optional: true

    scope :booked, -> { where(aasm_state: 'booked') }
  end

  class BookingResourceSku < ApplicationRecord
    belongs_to :booking

    has_one :booking_resource_sku_availability
  end

  class BookingResourceSkuAvailability < ApplicationRecord
    belongs_to :booking_resource_sku
    belongs_to :booked_by, class_name: 'User', optional: true
  end

  def up
    add_reference :booking_resource_sku_availabilities, :booked_by, index: true
    add_column :booking_resource_sku_availabilities, :booked_at, :datetime

    Booking.booked.each do |booking|
      booking.booking_resource_skus.each do |booking_resource_sku|
        next unless booking_resource_sku.booking_resource_sku_availability.present?

        booking_resource_sku.booking_resource_sku_availability.update(
          booked_by: booking.assignee || User.first,
          booked_at: booking.updated_at
        )
      end
    end
  end

  def down
    remove_reference :booking_resource_sku_availabilities, :booked_by, index: true
    remove_column :booking_resource_sku_availabilities, :booked_at, :datetime
  end
end
