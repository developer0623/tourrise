# frozen_string_literal: true

module Customers
  class ListCustomers
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      name
      birthdate
      bookings_count
      total_earnings
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "name"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.customers = contact_customers.or(participant_customers)

      filter_customers
      sort_customers
      paginate_customers
    end

    private

    def contact_customers
      Customer.includes(:bookings, :participate_bookings)
              .where.not(bookings: { aasm_state: :draft })
              .where.not(bookings: { id: nil })
              .where.not(placeholder: true)
    end

    def participant_customers
      Customer.includes(:bookings, :participate_bookings)
              .where.not(participate_bookings_customers: { aasm_state: :draft })
              .where(bookings: { id: nil })
              .where.not(placeholder: true)
    end

    def filter_customers
      return if context.filter.blank?

      context.customers = CustomersService.new(context.customers).search(context.filter[:q]) if context.filter[:q].present?
    end

    def sort_customers
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_column
    end

    def sort_by_column
      sort_by_name if context.sort_by == "name"
      sort_by_birthdate if context.sort_by == "birthdate"
      sort_by_bookings_count if context.sort_by == "bookings_count"
      sort_by_total_earnings if context.sort_by == "total_earnings"
    end

    def sort_by_name
      context.customers = context.customers.order(first_name: context.sort_order, last_name: context.sort_order)
    end

    def sort_by_birthdate
      context.customers = context.customers.order(birthdate: context.sort_order)
    end

    def sort_by_bookings_count
      context.customers = context.customers.left_joins(:bookings).group(:id).order("COUNT(bookings.id) #{context.sort_order}")
    end

    def sort_by_total_earnings
      context.customers = context.customers.left_joins(bookings: :booking_resource_skus).group("id").order("SUM(booking_resource_skus.quantity * booking_resource_skus.price_cents) #{context.sort_order}")
    end

    def paginate_customers
      context.customers = context.customers.page(context.page)
    end
  end
end
