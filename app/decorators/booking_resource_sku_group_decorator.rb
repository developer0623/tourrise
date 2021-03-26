# frozen_string_literal: true

class BookingResourceSkuGroupDecorator < Draper::Decorator
  delegate_all

  decorates_association :booking_resource_skus
  decorates_association :invoices
  decorates_association :cancellation

  def available_booking_resource_skus
    object.booking.booking_resource_skus.groupable
  end
end
