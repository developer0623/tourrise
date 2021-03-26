# frozen_string_literal: true

module InputHelper
  def input_tag_by_field_type(field_type)
    return :text_field unless field_type

    case field_type
    when "checkbox"
      :check_box
    when "email"
      :email_field
    when "number"
      :number_field
    when "date"
      :date_field
    else
      :text_field
    end
  end

  def cost_center_options
    [[t("empty"), nil], *CostCenter.all.pluck(:name, :id)]
  end

  def financial_account_options
    [[t("empty"), nil], *FinancialAccount.all.pluck(:name, :id)]
  end
end
