# frozen_string_literal: true

class ResourceSkuDecorator < Draper::Decorator
  delegate_all

  decorates_association :resource_sku_pricings

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def build_resource_sku_pricing
    object.resource_sku_pricings.new.decorate
  end

  def featured_image
    object.images.first
  end

  def resource_name
    object.resource.name
  end

  def full_name
    "#{resource_name} - #{name}"
  end

  def label
    object.name
  end

  def complete_handle
    object.resource.handle.present? ? object.handle.prepend("#{object.resource.handle}-") : object.handle
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

  def display_tag_names
    object.tags.with_translations(I18n.locale).pluck(:name).join(", ")
  end

  def display_tag_handles
    object.tags.with_translations(I18n.locale).pluck(:handle).join("-")
  end

  def financial_information
    [
      {
        attr: ResourceSku.human_attribute_name(:vat),
        val: object.vat
      },
      *resource_sku_pricings.map do |pricing|
        {
          attr: h.t("participant_types.#{pricing.participant_type || 'all'}"),
          val: pricing.display_information
        }
      end
    ]
  end
end
