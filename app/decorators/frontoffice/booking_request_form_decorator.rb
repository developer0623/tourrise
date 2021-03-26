# frozen_string_literal: true

module Frontoffice
  class BookingRequestFormDecorator < BookingFormDecorator
    def starts_on
      object.starts_on || configured_starts_on
    end

    def ends_on
      object.ends_on || configured_ends_on
    end

    def next_step_path
      return super unless next_step_handle == "accommodation_request"

      h.frontoffice_booking_accommodations_path(object.booking.scrambled_id, room: 1)
    end

    def current_step_handle
      :request
    end

    def show_wishyouwhat_field?
      object.product_sku.product_sku_booking_configuration&.wishyouwhat_on_first_step?
    end
  end
end
