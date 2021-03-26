# frozen_string_literal: true

module Frontoffice
  module Decoratable
    include Draper::Decoratable

    def decorator_class
      "#{self.class.name}Decorator".constantize
    end
  end
end
