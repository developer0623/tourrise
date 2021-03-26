# frozen_string_literal: true

class TimelineEntryDecorator < Draper::Decorator
  delegate_all

  def display_header
    "<time class=\"Attr\" datetime=\"#{timestamp.strftime('%Y-%m-%d %H:%M')}\">"\
      "<span class=\"Attr-main\">#{l(timestamp.to_date, format: :default)}</span>"\
      "<span class=\"Attr-sub\">#{l(timestamp, format: :time_only)}</span>"\
    "</time>".html_safe
  end

  def display_message
    translation_key = ["bookings.show.timeline.messages.#{message[0]}"]

    user = message[1]&.fetch(:user, nil)
    if user
      name = "#{user.first_name} #{user.last_name}"
      translation_key << { name: name }
    end

    I18n.t(*translation_key)
  end
end
