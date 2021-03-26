# frozen_string_literal: true

class ResourceTypeDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def icon_name
    "ResourceTypeIcon::#{object.handle.upcase}".constantize
  end
end
