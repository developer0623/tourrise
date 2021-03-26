# frozen_string_literal: true

class ParticipantDecorator < Draper::Decorator
  decorates :customer

  delegate_all

  decorates_association :booking

  def name
    if object.placeholder?
      return h.content_tag(:div, class: "Empty") do
        h.t("participants.placeholder_name")
      end
    end

    "#{h.display_name(first_name: first_name, last_name: last_name)} #{participant_type_indicator}"
  end

  def participant_type_indicator
    return unless object.participant_type.present?

    "(#{h.t("participant_types.#{object.participant_type}").first.upcase})"
  end

  def localized_birthdate
    return unless object.birthdate.present?

    h.l(object.birthdate, format: :default)
  end

  def age
    return unless object.birthdate.present?

    h.calculate_age(object.birthdate, object.booking.starts_on)
  end

  def editable_by_user?
    return false if h.current_user.id == FrontofficeUser.id

    object.persisted?
  end
end
