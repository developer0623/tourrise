# frozen_string_literal: true

module Frontoffice
  class SelectAccommodation
    include Interactor

    def call
      BookingResourceSku.transaction do
        current_room_selection&.destroy

        context.fail!(message: I18n.t("frontoffice.errors.too_many_rooms")) if requested_rooms_count <= current_rooms_count

        create_booking_resource_sku
      end
    end

    private

    def current_step
      context.booking.product.product_frontoffice_steps.find_by(frontoffice_steps: { handle: :accommodation_request })
    end

    def booking_room_assignment
      context.booking.booking_room_assignments[context.room.to_i - 1]
    end

    def requested_rooms_count
      context.booking.rooms_count
    end

    def current_rooms_count
      context.booking.booking_resource_skus.with_resource_type_id(resource_type.id).count
    end

    def rooms_remaining
      requested_rooms_count - context.room.to_i
    end

    def current_room_selection
      return unless context.room.present?

      booked_accommodations = context
                              .booking
                              .booking_resource_skus
                              .with_resource_type_id(resource_type.id)

      booked_accommodations[context.room.to_i - 1]
    end

    def resource_type
      @resource_type ||= ResourceType.accommodation
    end

    def calculate_price
      Pricings::ResourceSku::CalculateTotalPrice.call(
        resource_sku: ResourceSku.find_by(id: context.resource_sku_id),
        starts_on: context.booking.starts_on,
        ends_on: context.booking.ends_on,
        adults: booking_room_assignment.adults,
        kids: booking_room_assignment.kids,
        babies: booking_room_assignment.babies
      ).price
    end

    def create_booking_resource_sku
      booking_context = BookingResourceSkus::CreateBookingResourceSku.call(
        booking_id: context.booking.id,
        resource_sku_id: context.resource_sku_id,
        params: booking_resource_sku_params,
        fail_on_unavailability: true
      )

      if booking_context.success?
        context.next_step_handle = current_step.next_step.handle if rooms_remaining.zero?
      else
        context.fail!(message: booking_context.message)
      end
    end

    def booking_resource_sku_params
      {
        "booking_resource_sku" => {
          "starts_on" => context.booking.starts_on,
          "ends_on" => context.booking.ends_on,
          "price" => calculate_price
        }
      }.with_indifferent_access
    end
  end
end
