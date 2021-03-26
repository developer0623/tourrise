# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  def initialize(level: :info, messages:)
    @messages = Array(messages)
    @level = level&.to_sym
  end

  def background_color
    case @level
    when :info
      "bg-blue-50"
    when :success
      "bg-green-50"
    when :warning
      "bg-yellow-50"
    when :alert
      "bg-red-50"
    else
      "bg-blue-50"
    end
  end

  def button_color
    case @level
    when :info
      "bg-blue-50 text-blue-500 hover:bg-blue-100 focus:ring-offset-blue-50 focus:ring-blue-600"
    when :success
      "bg-green-50 text-green-500 hover:bg-green-100 focus:ring-offset-green-50 focus:ring-green-600"
    when :warning
      "bg-yellow-50 text-yellow-500 hover:bg-yellow-100 focus:ring-offset-yellow-50 focus:ring-yellow-600"
    when :alert
      "bg-red-50 text-red-500 hover:bg-red-100 focus:ring-offset-red-50 focus:ring-red-600"
    else
      "bg-blue-50 text-blue-500 hover:bg-blue-100 focus:ring-offset-blue-50 focus:ring-blue-600"
    end
  end

  def message_color
    case @level
    when :info
      "text-blue-800"
    when :success
      "text-green-800"
    when :warning
      "text-yellow-800"
    when :alert
      "text-red-800"
    else
      "text-blue-800"
    end
  end
end
