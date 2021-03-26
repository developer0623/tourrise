crumb :product_booking_resource_skus do |product|
  link I18n.t("navigation.product_booking_resource_skus"), product_product_booking_resource_skus_path(product)

  parent :product, product
end
