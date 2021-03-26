# frozen_string_literal: true

class ProductDecorator < Draper::Decorator
  delegate_all
  decorates_associations :product_skus
  decorates_associations :seasons
  decorates_associations :current_season

  def single_variant?
    object.product_skus.count == 1
  end

  def current_active_season
    return unless object.current_season.present? && object.current_season.published?

    current_season
  end

  def product_sku
    return unless product_skus.any?

    object.product_skus.first.decorate
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

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
