crumb :easybill do
  link  I18n.t("navigation.easybill"), settings_path
  parent :settings
end

crumb :employees do |employee|
  link  I18n.t("navigation.employees"), employees_path
  parent :easybill
end

crumb :new_employee do |employee|
  link I18n.t("easybill.employees.new.title"), "#"
  parent :employees, employee
end

crumb :edit_employee do |employee|
  link I18n.t("easybill.employees.edit.title", name: employee.user&.first_name), "#"
  parent :employees, employee
end

crumb :product_configurations do |product_configuration|
  link  I18n.t("navigation.product_configurations"), product_configurations_path
  parent :easybill
end

crumb :new_product_configuration do |product_configuration|
  link I18n.t("easybill.product_configurations.new.title"), "#"
  parent :product_configurations, product_configuration
end

crumb :edit_product_configuration do |product_configuration|
  link I18n.t("easybill.product_configurations.edit.title", name: product_configuration.product&.name), "#"
  parent :product_configurations, product_configuration
end
