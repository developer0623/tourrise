# frozen_string_literal: true

class AtFutureValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return unless attribute.present?
    return unless value.present?

    object.errors[attribute] << (options[:message] || "must be in the future") if value < Date.today
  end
end
