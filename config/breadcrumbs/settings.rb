crumb :settings do
  link I18n.t("navigation.settings"), main_app.settings_path
  parent :root
end

crumb :me do
  link I18n.t("settings.me.show.title"), main_app.settings_me_path
  parent :settings
end

crumb :me_edit do
  link I18n.t("settings.me.edit.title"), main_app.settings_me_path
  parent :me
end

crumb :users do
  link I18n.t("settings.users.index.title"), main_app.users_path
  parent :settings
end

crumb :user do |user|
  link [user.first_name, user.last_name].join(' '), "#"
  parent :users
end

crumb :user_invite do
  link I18n.t("settings.users.invite.title"), main_app.new_user_path
  parent :users
end

crumb :user_edit do |user|
  link I18n.t("settings.users.edit.title"), main_app.edit_user_path(user)
  parent :user, user
end

crumb :frontoffice_settings_new do |frontoffice_setting|
  link I18n.t("settings.frontoffice_settings.new.title"), main_app.new_settings_frontoffice_setting_path(frontoffice_setting)
  parent :settings
end

crumb :frontoffice_settings_edit do |frontoffice_setting|
  link I18n.t("settings.frontoffice_settings.edit.title"), main_app.edit_settings_frontoffice_setting_path(frontoffice_setting)
  parent :settings
end

crumb :global_configurations_new do |global_configuration|
  link I18n.t("settings.global_configurations.new.title"), main_app.new_settings_global_configuration_path(global_configuration)
  parent :settings
end

crumb :global_configurations_edit do |global_configuration|
  link I18n.t("settings.global_configurations.edit.title"), main_app.edit_settings_global_configuration_path(global_configuration)
  parent :settings
end

crumb :accounting_records do
  link I18n.t("settings.accounting_records.title"), main_app.payments_path
  parent :settings
end

crumb :statements do
  link 'Statements'
  parent :settings
end

crumb :cancellation_reasons do
  link I18n.t("settings.cancellation_reasons.index.title"), main_app.settings_cancellation_reasons_path
  parent :settings
end

crumb :new_cancellation_reason do
  link I18n.t("settings.cancellation_reasons.new.title"), main_app.new_settings_cancellation_reason_path
  parent :cancellation_reasons
end

crumb :edit_cancellation_reason do |cancellation_reason|
  link I18n.t("settings.cancellation_reasons.edit.title", name: cancellation_reason.name), main_app.edit_settings_cancellation_reason_path(cancellation_reason)
  parent :cancellation_reasons
end
