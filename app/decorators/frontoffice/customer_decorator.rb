# frozen_string_literal: true

module Frontoffice
  class CustomerDecorator < ::CustomerDecorator
    def phone
      if primary_phone || secondary_phone
        break_if_needed = "<br>" if primary_phone && secondary_phone

        "#{primary_phone}#{break_if_needed}#{secondary_phone}".html_safe
      else
        h.empty_state(h.t("not_entered"))
      end
    end

    def name
      if first_name || last_name
        full_name
      else
        h.empty_state(h.t("not_entered"))
      end
    end
  end
end
