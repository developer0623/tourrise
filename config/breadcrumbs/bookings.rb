crumb :bookings do
  link  I18n.t("navigation.bookings"), bookings_path
  parent :root
end

crumb :booking  do |booking|
  link booking.id, booking_path(booking)
  parent :bookings
end

crumb :booking_new do
  link I18n.t("add"), "#"
  parent :bookings
end

crumb :booking_edit do |booking|
  link I18n.t("navigation.edit"), "#"
  parent :booking, booking
end
