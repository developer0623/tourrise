crumb :booking_resource_sku  do |booking_resource_sku|
  link I18n.t("navigation.booking_resource_skus"), "#"
  link(booking_resource_sku.id, booking_booking_resource_sku_path(booking_resource_sku.booking_id,
                                                                  id: booking_resource_sku.id))
  parent :booking, booking_resource_sku.booking
end

crumb :booking_resource_sku_new do |booking, step|
  link I18n.t("booking_resource_skus.new.#{step}_title"), "#"
  parent :booking, booking
end

crumb :booking_resource_sku_edit do |booking_resource_sku|
  link I18n.t("edit"), "#"
  parent :booking_resource_sku, booking_resource_sku
end
