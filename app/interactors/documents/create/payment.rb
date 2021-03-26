# frozen_string_literal: true

module Documents
  module Create
    class Payment
      include Interactor

      DEFAULT_GRACE_PERIOD = 14
      PAYMENT_DAYS_BEFORE_START = 30.days

      def call
        context.payment = ::Payment.new(
          booking_invoice_id: context.booking_invoice.id,
          price: context.booking_invoice.total_price,
          due_on: calculate_due_on
        )

        context.fail!(message: context.payment.errors.full_messages) unless context.payment.save
      end

      def calculate_due_on
        payment_offset = (((context.booking.starts_on - PAYMENT_DAYS_BEFORE_START)) - Time.zone.now.to_date).to_i

        if payment_offset.positive?
          payment_offset.days.from_now
        elsif (-15..0).to_a.include?(payment_offset)
          DEFAULT_GRACE_PERIOD.days.from_now
        else
          Date.today
        end
      end
    end
  end
end
