# frozen_string_literal: true

module Bookings
  class SortBookings
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      created_at
      updated_at
      customer_name
      product_name
      participants_count
      status
      due_on
      secondary_state
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "created_at"
    DEFAULT_SORT_ORDER = "asc"

    def call
      return if context.sort.blank?

      context.fail!(message: "booking context missing") unless context.bookings.present?

      fetch_sort_context

      send("sort_by_#{context.sort_by}")

      context.bookings = context.bookings.page(context.page).per(context.limit || 25)
    end

    def fetch_sort_context
      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)
    end

    private

    def sort_by_customer_name
      context.bookings = context.bookings.order("customers.first_name #{context.sort_order}", "customers.last_name #{context.sort_order}")
    end

    def sort_by_product_name
      context.bookings = context.bookings.order("product_translations.name #{context.sort_order}")
    end

    def sort_by_participants_count
      context.bookings = context.bookings.left_joins(:participants).group(:id).order("COUNT(customers.id) #{context.sort_order}")
    end

    def sort_by_created_at
      context.bookings = context.bookings.order(created_at: context.sort_order)
    end

    def sort_by_updated_at
      context.bookings = context.bookings.order(updated_at: context.sort_order)
    end

    def sort_by_status
      context.bookings = context.bookings.order(aasm_state: context.sort_order)
    end

    def sort_by_secondary_state
      context.bookings = context.bookings.order(secondary_state: context.sort_order)
    end

    def sort_by_due_on
      context.bookings = context.bookings.order(due_on: context.sort_order)
    end
  end
end
