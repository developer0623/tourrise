crumb :reports do
  link I18n.t("navigation.reports"), reports_path
  parent :root
end

crumb :reports_product_skus do
  link I18n.t("breadcrumbs.reports.product_skus"), reports_product_skus_path
  parent :reports
end
