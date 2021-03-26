# frozen_string_literal: true

module ApplicationHelper
  def display_name(first_name:, last_name:)
    "#{first_name} #{last_name}"
  end

  def empty_state(msg)
    "<span class=\"Empty\">#{msg}</span>".html_safe
  end

  def plural_model_name(model)
    model.model_name.human(count: 2)
  end
end
