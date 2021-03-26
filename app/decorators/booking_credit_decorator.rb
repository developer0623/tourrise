# frozen_string_literal: true

class BookingCreditDecorator < Draper::Decorator
  delegate_all

  def invoice_published?
    invoice.scrambled_id.present?
  end

  def invoice_link
    return invoice_details_link unless invoice_published?

    invoice_frontoffice_link
  end

  private

  def invoice_details_link
    h.link_to(invoice.decorate.number, h.public_send("booking_invoice_path", invoice.id))
  end

  def invoice_frontoffice_link
    h.link_to(invoice.decorate.number, h.public_send("frontoffice_booking_invoice_path", invoice.booking.scrambled_id, invoice.scrambled_id))
  end
end
