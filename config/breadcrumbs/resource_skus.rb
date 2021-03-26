crumb :resource_sku do |resource_sku|
  link ResourceSku.model_name.human(count: 2)
  link resource_sku.name, resource_sku_path(id: resource_sku.id)
  parent :resource,  resource_sku.resource
end

crumb :resource_sku_edit do |resource_sku|
  link I18n.t("edit"), "#"
  parent :resource_sku, resource_sku
end
