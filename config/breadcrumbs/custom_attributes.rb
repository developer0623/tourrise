crumb :custom_attributes do
  link  I18n.t("navigation.custom_attributes"), settings_custom_attributes_path
  parent :settings
end

crumb :edit_custom_attribute do |custom_attribute|
  link I18n.t("settings.custom_attributes.edit.title", name: custom_attribute.name), "#"
  parent :custom_attributes, custom_attribute
end

crumb :new_custom_attribute do |custom_attribute|
  link I18n.t("settings.custom_attributes.new.title", name: custom_attribute.name), "#"
  parent :custom_attributes, custom_attribute
end
