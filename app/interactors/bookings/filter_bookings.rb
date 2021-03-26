# frozen_string_literal: true

module Bookings
  class FilterBookings
    include Interactor

    VALID_OPERATORS = %w[
      eq
      lt
      lteq
      gt
      gteq
    ].freeze

    UNASSIGNED = "0"

    def call
      return if context.filter.blank?

      context.fail!(message: "booking context missing") unless context.bookings.present?

      filter_by_status
      filter_by_product_id
      filter_by_product_sku_id
      filter_by_season_id
      filter_by_assignee_id
      filter_by_created_at
      filter_by_updated_at
      filter_by_secondary_state
    end

    def filter_by_status
      return if context.filter[:status].blank?

      context.bookings = context.bookings.public_send(context.filter[:status])
    end

    def filter_by_secondary_state
      return if context.filter[:secondary_state].blank?

      context.bookings = context.bookings.where(secondary_state: context.filter[:secondary_state])
    end

    def filter_by_product_id
      return if context.filter[:product_id].blank?

      context.bookings = context.bookings.for_product_id(context.filter[:product_id])
    end

    def filter_by_product_sku_id
      return if context.filter[:product_sku_id].blank?

      context.bookings = context.bookings.where(product_sku_id: context.filter[:product_sku_id])
    end

    def filter_by_season_id
      return if context.filter[:season_id].blank?

      context.bookings = context.bookings.where(season_id: context.filter[:season_id])
    end

    def filter_by_assignee_id
      assignee_id = context.filter[:assignee_id]

      return if assignee_id.blank?

      assignee_id = nil if assignee_id == UNASSIGNED

      context.bookings = context.bookings.for_assignee_id(assignee_id)
    end

    def filter_by_created_at
      return if context.filter[:created_at].blank?

      context.bookings = context.bookings.where(created_at_query)
    end

    def filter_by_updated_at
      return if context.filter[:updated_at].blank?

      context.bookings = context.bookings.where(updated_at_query)
    end

    def created_at_query
      Booking.arel_table[:created_at].public_send(created_at_operator, parsed_created_at_datetime)
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

    def updated_at_query
      Booking.arel_table[:updated_at].public_send(updated_at_operator, parsed_updated_at_datetime)
    end

    def updated_at_operator
      operator = context.filter[:updated_at].fetch(:operator, "")

      return operator if VALID_OPERATORS.include?(operator)

      context.fail!(message: "invalid operator: supported operators are #{VALID_OPERATORS}")
    end

    def parsed_updated_at_datetime
      DateTime.parse(context.filter[:updated_at].fetch(:value, ""))
    rescue ArgumentError
      context.fail!(message: "invalid datetime: datetime should be iso8601 conform (https://en.wikipedia.org/wiki/ISO_8601).")
    end
  end
end
