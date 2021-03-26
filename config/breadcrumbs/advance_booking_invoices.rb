crumb :advance_booking_invoice do |advance_booking_invoice|
  link I18n.t('navigation.advance_booking_invoices'), "#"
  link advance_booking_invoice.number, "#"
  parent :booking, advance_booking_invoice.booking
end
