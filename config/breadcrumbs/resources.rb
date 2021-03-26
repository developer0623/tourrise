crumb :resources do
  link I18n.t("navigation.resources"), resources_path
  parent :root
end

crumb :resource do |resource|
  link resource.name, resource_path(resource)
  parent :resources
end

crumb :resource_new do
  link I18n.t("create"), "#"
  parent :resources
end

crumb :resource_edit do |resource|
  link I18n.t("edit"), "#"
  parent :resource, resource
end
