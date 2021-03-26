crumb :booking_offer do |booking_offer|
  link I18n.t('navigation.booking_offers'), "#"
  link booking_offer.number, "#"
  parent :booking, booking_offer.booking
end
