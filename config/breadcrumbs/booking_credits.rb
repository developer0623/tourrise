crumb :booking_credit_new do |booking|
  link I18n.t("navigation.new_booking_credit"), "#"
  parent :booking, booking
end

crumb :booking_credit_edit do |booking_credit|
  link I18n.t("navigation.edit_booking_credit", id: booking_credit.id), "#"
  parent :booking, booking_credit.booking
end
