# frozen_string_literal: true

module BookingInvoices
  module Index
    class Filter
      include Interactor

      VALID_OPERATORS = %w[
        eq
        lt
        lteq
        gt
        gteq
      ].freeze

      def call
        return if context.filter.blank?

        filter_by_created_at
      end

      private

      def filter_by_created_at
        return if context.filter[:created_at].blank?

        context.booking_invoices = context.booking_invoices.where(created_at_query)
      end

      def created_at_query
        BookingInvoice.arel_table[:created_at].public_send(created_at_operator, parsed_created_at_datetime)
      end

      def created_at_operator
        operator = context.filter[:created_at].fetch(:operator, "")

        return operator if VALID_OPERATORS.include?(operator)

        context.fail!(message: "invalid operator: supported operators are #{VALID_OPERATORS}")
      end

      def parsed_created_at_datetime
        DateTime.parse(context.filter[:created_at].fetch(:value, ""))
      rescue ArgumentError
        context.fail!(message: "invalid datetime: datetime should be iso8601 conform (https://en.wikipedia.org/wiki/ISO_8601).")
      end
    end
  end
end
