# frozen_string_literal: true

module Bookings
  class ListResourceSkus
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      name
      price
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "name"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.resource_skus = ResourceSku.with_translations(I18n.locale).with_resource_translations(I18n.locale).includes(:resource_sku_pricings, resource: :resource_type)

      filter_resource_skus
      sort_resource_skus

      context.resource_skus = context.resource_skus.page(context.page)
    end

    private

    def filter_resource_skus
      return unless context.filter.present?

      filter_resource_skus_by_resource_type
      filter_resource_skus_by_product
      filter_resource_skus_by_search_term
    end

    def sort_resource_skus
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_column
    end

    def sort_by_column
      sort_by_name if context.sort_by == "name"
      sort_by_price if context.sort_by == "price"
    end

    def sort_by_name
      context.resource_skus = context.resource_skus.order("resource_translations.name #{context.sort_order}")
    end

    def sort_by_price
      # TODO: by a rails arel genius
      context.resource_skus = context.resource_skus
    end

    def filter_resource_skus_by_resource_type
      return unless context.filter[:resource_type_id].present?

      context.resource_skus = context.resource_skus.where(
        resources: { resource_type_id: context.filter[:resource_type_id] }
      )
    end

    def filter_resource_skus_by_product
      return unless context.filter[:product_id].present?

      product = Product.find_by(id: context.filter[:product_id])
      return unless product.present?

      context.resource_skus = context.resource_skus.where(resource_id: product.resources.pluck(:id))
    end

    def filter_resource_skus_by_search_term
      return unless context.filter[:q].present?

      context.resource_skus = name_matches.or(handle_matches).or(resource_name_matches)
    end

    def name_matches
      context.resource_skus.where("lower(resource_sku_translations.name) LIKE ?", "%#{context.filter[:q]&.downcase}%")
    end

    def handle_matches
      context.resource_skus.where("lower(resource_skus.handle) LIKE ?", "%#{context.filter[:q]&.downcase}%")
    end

    def resource_name_matches
      context.resource_skus.where("lower(resource_translations.name) LIKE ?", "%#{context.filter[:q]&.downcase}%")
    end
  end
end
