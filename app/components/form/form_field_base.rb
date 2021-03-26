# frozen_string_literal: true

module Form
  class FormFieldBase < ViewComponent::Base
    def initialize(form_builder, field_name, options: {})
      @f = form_builder
      @field_name = field_name
      @options = options
    end

    def label_options
      {
        class: label_class
      }
    end

    def input_field_options
      input_field_options = {
        class: input_field_class
      }

      input_field_options[:autofocus] = @options[:autofocus] if @options[:autofocus].present?
      input_field_options[:autocomplete] = @options[:autocomplete] if @options[:autocomplete].present?
      input_field_options[:required] = @options[:required] if @options[:required].present?

      input_field_options
    end

    private

    def label_class
      "block text-sm font-medium text-gray-700"
    end

    def input_field_class
      %w[
        appearance-none
        block
        w-full
        px-3
        py-2
        border
        border-gray-300
        rounded-md
        shadow-sm
        placeholder-gray-400
        focus:outline-none
        focus:ring-indigo-500
        focus:border-indigo-500
        sm:text-sm
      ].join(" ")
    end
  end
end
