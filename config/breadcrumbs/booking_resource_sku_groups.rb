crumb :booking_resource_sku_group do |booking_resource_sku_group|
  link I18n.t("navigation.booking_resource_sku_groups"), booking_path(booking_resource_sku_group.booking)+"#BookingResourceSkus"
  link(booking_resource_sku_group.id, booking_path(booking_resource_sku_group.booking)+"#BookingResourceSkuGroup-#{booking_resource_sku_group.id}")
  parent :booking, booking_resource_sku_group.booking
end

crumb :booking_resource_sku_group_new do |booking|
  link I18n.t("navigation.new_booking_resource_sku_group"), "#"
  parent :booking, booking
end

crumb :booking_resource_sku_group_edit do |booking_resource_sku_group|
  link I18n.t("edit"), "#"
  parent :booking_resource_sku_group, booking_resource_sku_group
end
