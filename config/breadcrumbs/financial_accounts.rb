crumb :financial_accounts do
  link  I18n.t("navigation.financial_accounts"), settings_financial_accounts_path
  parent :settings
end

crumb :edit_financial_account do |financial_account|
  link I18n.t("financial_accounts.edit.title", name: financial_account.name), "#"
  parent :financial_accounts, financial_account
end

crumb :new_financial_account do |financial_account|
  link I18n.t("financial_accounts.new.title", name: financial_account.name), "#"
  parent :financial_accounts, financial_account
end
