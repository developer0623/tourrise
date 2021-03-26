# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  WHITELISTED_ATTRIBUTES = %w[
    title
    first_name
    last_name
    email
    sign_in_count
    confirmed_at
    created_at
    updated_at
  ].freeze

  delegate_all

  def display_name
    "#{first_name} #{last_name}"
  end

  def invitation_status
    return h.t("users.invitations.confirmed") if object.confirmed_at.present?

    h.t("users.invitations.open")
  end

  def attributes
    object.attributes.slice(*WHITELISTED_ATTRIBUTES)
  end
end
