crumb :customers do
  link  I18n.t("navigation.customers"), customers_path
  parent :root
end

crumb :customer do |customer|
  link  customer.id, customer_path(customer)
  parent :customers
end

crumb :customer_new do
  link I18n.t("add"), "#"
  parent :customers
end

crumb :customer_edit do |customer|
  link I18n.t("edit"), "#"
  parent :customer, customer
end
