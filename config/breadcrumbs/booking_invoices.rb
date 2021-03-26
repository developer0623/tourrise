crumb :booking_invoice do |booking_invoice|
  link I18n.t('navigation.booking_invoices'), "#"
  link booking_invoice.number, "#"
  parent :booking, booking_invoice.booking
end

crumb :booking_invoice_new do |booking|
  link I18n.t("navigation.new_booking_invoice"), "#"
  parent :booking, booking
end

crumb :advance_booking_invoice_new do |booking|
  link I18n.t("navigation.new_advance_booking_invoice"), "#"
  parent :booking, booking
end
