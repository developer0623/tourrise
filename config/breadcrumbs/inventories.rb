crumb :inventories do
  link  I18n.t("navigation.inventories"), inventories_path
  parent :root
end

crumb :inventory  do |inventory|
  link inventory.id, inventory_path(inventory)
  parent :inventories
end

crumb :inventory_new do
  link I18n.t("add"), "#"
  parent :inventories
end

crumb :inventory_edit do |inventory|
  link  I18n.t("edit"), "#"
  parent :inventory, inventory
end
