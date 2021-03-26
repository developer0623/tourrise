# frozen_string_literal: true

class BookingService
  attr_reader :booking

  def initialize(booking)
    @booking = booking
  end

  def offer_creatable?
    booking_offers_service.offer_creatable?
  end

  def offer_available?
    booking_offers_service.offer_available?
  end

  def invoice_creatable?
    booking_invoices_service.invoice_creatable?
  end

  def invoice_available?
    booking_invoices_service.invoice_available?
  end

  def committable?
    return false unless booking.may_commit?
    return false unless booking.booking_invoices.any?

    booking_invoices_service.invoice_available?
  end

  private

  def booking_invoices_service
    @booking_invoices_service ||= BookingInvoicesService.new(booking)
  end

  def booking_offers_service
    @booking_offers_service ||= BookingOffersService.new(booking)
  end
end
