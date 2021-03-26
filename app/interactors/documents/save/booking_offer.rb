# frozen_string_literal: true

module Documents
  module Save
    class BookingOffer < Base
      def call
        context.fail!(message: I18n.t("booking_offers.created_error")) unless booking_service.offer_creatable?

        super
      end

      private

      def event_name
        Event::BOOKING_OFFER_CREATED
      end
    end
  end
end
