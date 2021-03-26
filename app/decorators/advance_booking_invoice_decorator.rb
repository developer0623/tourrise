# frozen_string_literal: true

class AdvanceBookingInvoiceDecorator < BookingInvoiceDecorator
  decorates :advance_booking_invoice

  def initialize_advance_payment
    Payment.new(
      price: 0,
      due_on: Time.zone.today + GlobalConfiguration.term_of_first_payment.days
    )
  end

  def human_model_name
    h.t(object.class.model_name.i18n_key, scope: %i[activerecord models], count: 1)
  end

  private

  def frontoffice_path_method
    "frontoffice_booking_advance_invoice_path"
  end
end
