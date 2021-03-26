# frozen_string_literal: true

class BookingInvoiceDecorator < BookingDocumentDecorator
  def initialize_partial_payment
    Payment.new(
      price: partial_payment_price,
      due_on: Time.zone.today + GlobalConfiguration.term_of_first_payment.days
    )
  end

  def initialize_final_payment
    Payment.new(
      price: final_payment_price,
      due_on: final_payment_due_on
    )
  end

  def full_payment_booking_resource_skus
    undocumented_booking_resource_skus.reject(&:allow_partial_payment)
  end

  def partial_payment_booking_resource_skus
    undocumented_booking_resource_skus.select(&:allow_partial_payment)
  end

  # Change
  # rewrite it as already invoiced but not for a new one
  def undocumented_booking_credits
    booking_invoices_service.undocumented_booking_credits
  end

  def undocumented_booking_resource_skus
    booking_invoices_service.undocumented_booking_resource_skus.map(&:decorate)
  end

  def undocumented_booking_resource_sku_groups
    booking_invoices_service.undocumented_booking_resource_sku_groups.map(&:decorate)
  end

  def partially_payable?
    return false unless partial_payment_booking_resource_skus.any? || undocumented_booking_resource_sku_groups.any?
    return true if object.booking.starts_on > (Time.zone.today + GlobalConfiguration.term_of_first_payment.days + GlobalConfiguration.term_of_final_payment)

    false
  end

  private

  def easybill_document
    ::Easybill::Invoice.find_by(booking_invoice: object)
  end

  def final_payment_price
    return total_price unless partially_payable?

    total_price - partial_payment_price
  end

  def final_payment_due_on
    return Time.zone.tomorrow if short_term_booking

    [
      (object.booking.starts_on - GlobalConfiguration.term_of_final_payment.days),
      (Time.zone.today + GlobalConfiguration.term_of_first_payment.days)
    ].max
  end

  def partial_payment_price
    sum_for_partial_payment = if full_payment_booking_resource_skus.any?
                                total_price - full_payment_booking_resource_skus.sum(&:price)
                              else
                                total_price
                              end

    (sum_for_partial_payment * GlobalConfiguration.partial_payment_percentage / 100) + full_payment_booking_resource_skus.sum(&:price)
  end

  def short_term_booking
    object.booking.starts_on < (Time.zone.today + GlobalConfiguration.term_of_first_payment.days)
  end

  def booking_invoices_service
    @booking_invoices_service ||= BookingInvoicesService.new(object.booking)
  end
end
