crumb :bulk_edit_resource_sku_pricings do |resource_sku|
  link "Preisregeln"
  parent :resource_sku,  resource_sku
end

crumb :new_resource_sku_pricing do |resource_sku|
  link I18n.t("resource_sku_pricings.new.title")
  parent :resource_sku,  resource_sku
end

crumb :edit_resource_sku_pricing do |resource_sku_pricing|
  link I18n.t("resource_sku_pricings.edit.title")
  parent :bulk_edit_resource_sku_pricings, resource_sku_pricing.resource_sku
end