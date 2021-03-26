# frozen_string_literal: true

module Frontoffice
  class BookingRequestForm < BookingFormBase
    FORM_FIELDS = %w[creator_id product_sku_id starts_on ends_on adults kids babies wishyouwhat title].freeze

    attr_accessor(*FORM_FIELDS)

    validates :starts_on, :ends_on, :adults, :product_sku_id, :creator_id, presence: true
    validates :adults, numericality: { greater_than: 0 }
    validates :kids, :babies, numericality: { greater_than_or_equal_to: 0 }
    validates_with EndsOnAfterStartsOnValidator

    delegate :persisted?, to: :booking

    before_save :assign_rooms, unless: :persisted?
    before_save :build_room_assignments, unless: :persisted?
    before_save :build_participants, unless: :persisted?
    before_save :build_season, unless: :persisted?

    before_save :update_participants, if: :persisted?
    before_save :reset_room_assignments, if: :persisted?

    def self.initialize_from_booking(booking)
      form = super
      form.wishyouwhat = booking.wishyouwhat&.to_plain_text
      form
    end

    private

    def assign_rooms
      booking.rooms_count = 1
    end

    def build_room_assignments
      booking.booking_room_assignments.new(adults: adults, kids: kids, babies: babies)
    end

    def build_participants
      adults.to_i.times { booking.participants.adult.new(placeholder: true) }
      kids.to_i.times { booking.participants.kid.new(placeholder: true) }
      babies.to_i.times { booking.participants.baby.new(placeholder: true) }
    end

    def build_season
      current_active_season = product_sku.current_active_season
      return unless current_active_season.present?

      booking.season = current_active_season
    end

    def update_participants
      update_participant_type("adult")
      update_participant_type("kid")
      update_participant_type("baby")
    end

    def update_participant_type(participant_type_handle)
      difference = public_send(participant_type_handle.pluralize).to_i - booking.participants.public_send(participant_type_handle).count

      booking.participants.public_send(participant_type_handle).last(difference.abs).each(&:destroy) if difference.negative?
      difference.times { booking.participants.new(participant_type: participant_type_handle, placeholder: true) } if difference.positive?
    end

    def reset_room_assignments
      booking.booking_room_assignments.each(&:destroy)
      build_room_assignments
    end
  end
end
