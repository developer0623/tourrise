# frozen_string_literal: true

module Bookings
  class ListBookings
    include Interactor

    def call
      context.bookings = Booking.without_drafts.includes(
        :assignee,
        :customer
      ).with_product_translations(I18n.locale).with_product_sku_translations(I18n.locale)

      FilterBookings.call(context)
      SortBookings.call(context)

      context.bookings = context.bookings.page(context.page).per(context.limit || 25)
    end
  end
end
