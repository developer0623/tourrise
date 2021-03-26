# frozen_string_literal: true

class BookingDocumentsServiceBase
  attr_reader :booking

  def initialize(booking)
    @booking = booking
  end

  def document_creatable?
    return false if booking.unassigned?

    (undocumented_booking_resource_skus + undocumented_booking_resource_sku_groups + undocumented_booking_credits).flatten.compact.any?
  end

  def undocumented_booking_resource_skus
    BookingResourceSkus::Find.call(booking: booking).booking_resource_skus
  end

  def undocumented_booking_resource_sku_groups
    BookingResourceSkuGroups::Find.call(booking: booking).booking_resource_sku_groups
  end

  def undocumented_booking_credits
    BookingCredits::Find.call(booking: booking).booking_credits
  end

  def document_available?
    (undocumented_booking_resource_skus + undocumented_booking_resource_sku_groups + undocumented_booking_credits).flatten.compact.blank?
  end

  private

  def document_type
    raise "not implemented error"
  end
end
