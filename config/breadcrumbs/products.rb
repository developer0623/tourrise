crumb :products do
  link I18n.t("navigation.products"), products_path
  parent :root
end

crumb :product do |product|
  link product.name, product_path(product)
  parent :products
end

crumb :product_new do
  link I18n.t("add"), "#"
  parent :products
end

crumb :product_edit do |product|
  link I18n.t("navigation.edit"), "#"
  parent :product, product
end
