crumb :booking_events do |booking|
  link  I18n.t("navigation.booking_events"), booking_booking_events_path
  parent :booking, booking
end
