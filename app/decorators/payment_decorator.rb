# frozen_string_literal: true

class PaymentDecorator < Draper::Decorator
  delegate_all

  def price_with_symbol
    h.humanized_money_with_symbol(object.price)
  end

  def show_due_on(index)
    "#{I18n.t('booking_form.booking_invoice.payment')} #{index} (#{I18n.t('booking_form.booking_invoice.due_on')} #{l(payment.due_on)})"
  end
end
