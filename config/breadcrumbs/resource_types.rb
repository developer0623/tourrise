crumb :resource_types do
  link I18n.t("navigation.resource_types"), resource_types_path
  parent :root
end

crumb :resource_type do |resource_type|
  link resource_type.id, resource_type_path(resource_type)
  parent :resources
end
