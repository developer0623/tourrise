# frozen_string_literal: true

module BookingCredits
  module RecalculatePrice
    class ForCreated
      include Interactor

      delegate :created_booking_credits, to: :context

      def call
        context.created_booking_credits_price_info = created_booking_credits_price_info
      end

      private

      def created_booking_credits_price_info
        created_booking_credits.each_with_object({}) do |created_booking_credit, info|
          info[created_booking_credit.id] = info_for_booking_credit(created_booking_credit)
        end
      end

      def info_for_booking_credit(booking_credit)
        { total_price: booking_credit.price }
      end
    end
  end
end
