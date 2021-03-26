# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(color: "indigo")
    @color =
      case color
      when "indigo"
        "text-white bg-indigo-600 hover:bg-indigo-700"
      when "white"
        "border-gray-300 bg-white text-gray-700 hover:bg-gray-50"
      end
  end
end
