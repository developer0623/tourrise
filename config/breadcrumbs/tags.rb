crumb :tags do
  link  I18n.t("navigation.tags"), settings_tags_path
  parent :settings
end

crumb :edit_tag do |tag|
  link I18n.t("settings.tags.edit.title", name: tag.name), "#"
  parent :tags, tag
end

crumb :new_tag do |tag|
  link I18n.t("settings.tags.new.title", name: tag.name), "#"
  parent :tags, tag
end
