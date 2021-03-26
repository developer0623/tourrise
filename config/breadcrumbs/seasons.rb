crumb :season_new do |product_id|
  link I18n.t("seasons.breadcrumbs.add"), new_product_season_path(product_id)
  parent :product, Product.find(product_id)
end

crumb :season do |season|
  link Season.model_name.human(count: 2)
  link season.name
  parent :product, season.product
end

crumb :season_edit do |season|
  link I18n.t("seasons.breadcrumbs.edit"), edit_season_path(season)
  parent :season, season
end
