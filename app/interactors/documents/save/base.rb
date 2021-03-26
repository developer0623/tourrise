# frozen_string_literal: true

module Documents
  module Save
    class Base
      include Interactor

      delegate :document, :booking, to: :context

      def call
        context.fail!(message: document.errors.full_messages) unless document.save

        PublishEventJob.perform_later(event_name, publish_payload)
      end

      private

      def event_name
        raise "Set event name!"
      end

      def booking_service
        @booking_service ||= BookingService.new(booking)
      end

      def publish_payload
        {
          "id" => document.id,
          "booking_id" => document.booking_id
        }
      end
    end
  end
end
