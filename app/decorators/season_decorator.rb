# frozen_string_literal: true

class SeasonDecorator < Draper::Decorator
  delegate_all

  def display_published_at
    localized_published_at || h.t("seasons.unpublished")
  end

  def localized_published_at
    return unless object.published_at.present?

    h.l(object.published_at, format: :long)
  end
end
