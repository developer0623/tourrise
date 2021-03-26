crumb :cost_centers do
  link  I18n.t("navigation.cost_centers"), settings_cost_centers_path
  parent :settings
end

crumb :edit_cost_center do |cost_center|
  link I18n.t("cost_centers.edit.title", name: cost_center.name), "#"
  parent :cost_centers, cost_center
end

crumb :new_cost_center do |cost_center|
  link I18n.t("cost_centers.new.title", name: cost_center.name), "#"
  parent :cost_centers, cost_center
end
