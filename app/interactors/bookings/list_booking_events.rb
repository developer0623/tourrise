# frozen_string_literal: true

module Bookings
  class ListBookingEvents
    include Interactor::Organizer

    delegate :booking, to: :context

    SUPPORTED_SORT_BY_VALUES = %w[
      created_at
      item_type
      event
      whodunnit
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "created_at"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.events = PaperTrail::Version.where(item: search_items)
      filter_events
      sort_events
      context.events = context.events.page(context.page).per(context.limit || 25)
    end

    def search_items
      items = []
      items << booking
      items << booking.customer
      items += booking.participants
      items += booking.booking_offers
      items += booking.booking_invoices
      items += booking.booking_resource_skus.with_deleted
      items += booking.booking_resource_sku_groups.with_deleted
      items
    end

    def sort_events
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_column
    end

    def sort_by_column
      case context.sort_by
      when "created_at"
        sort_by_timestamp
      when "item_type"
        sort_by_item_type
      when "event"
        sort_by_event
      when "whodunnit"
        sort_by_whodunnit
      end
    end

    def sort_by_item_type
      context.events = context.events.order("item_type #{context.sort_order}", "customers.last_name #{context.sort_order}")
    end

    def sort_by_event
      context.events = context.events.order("event #{context.sort_order}")
    end

    def sort_by_timestamp
      context.events = context.events.order("created_at #{context.sort_order}")
    end

    def sort_by_whodunnit
      context.events = context.events.order("whodunnit #{context.sort_order}")
    end

    def filter_events
      return if context.filter.blank?

      filter_by_event
      filter_by_item_type
      filter_by_created_at
    end

    def filter_by_event
      return if context.filter[:event].blank?

      context.events = context.events.where(event: context.filter[:event])
    end

    def filter_by_item_type
      return if context.filter[:item_type].blank?

      context.events = context.events.where(item_type: context.filter[:item_type])
    end

    def filter_by_created_at
      return if context.filter[:created_at].blank?

      context.events = context.events.where(created_at_query)
    end
  end
end
