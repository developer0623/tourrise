crumb :product_sku_edit do |product_sku|
  link I18n.t("navigation.edit"), "#"
  parent :product, product_sku.product
end
