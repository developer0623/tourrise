crumb :product_participants do |product|
  link I18n.t("navigation.participants"), product_product_participants_path(product)

  parent :product, product
end
