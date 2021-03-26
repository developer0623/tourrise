# frozen_string_literal: true

class CancellationDecorator < Draper::Decorator
  delegate_all

  def time
    created_at.strftime("%b #{created_at.day.ordinalize} %Y at %I:%M%P")
  end

  def message
    message_params = { time: time, user: user.name, reason: cancellation_reason.name }

    h.t("cancellation_reasons.cancellation_message", message_params)
  end
end
