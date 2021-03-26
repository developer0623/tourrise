# frozen_string_literal: true

class ResourceDecorator < Draper::Decorator
  delegate_all

  decorates_association :resource_skus

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def available_tags
    Tag.all.map do |tag|
      {
        code: tag.handle,
        value: tag.name,
        searchBy: tag.translations.map(&:name).join(", ")
      }
    end
  end

  def assigned_tags
    object.tags.map do |tag|
      {
        code: tag.handle,
        value: tag.name,
        searchBy: tag.translations.map(&:name).join(", ")
      }
    end
  end
end
