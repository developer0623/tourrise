# frozen_string_literal: true

module ActionView
  module Helpers
    class WaveFormBuilder < FormBuilder
      def error_tag(method, _tag_value, options = {})
        object = objectify_options(options).fetch(:object, nil)

        return unless object && object.errors[method].any?

        if options[:class].present?
          options[:class] += " Input--invalid"
        else
          options[:class] = "Input--invalid"
        end

        @template.content_tag(:div, options) do
          object.errors.full_message(method, object.errors[method].join(", "))
        end
      end
    end
  end
end
