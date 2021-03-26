# frozen_string_literal: true

module Products
  class ListProducts
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[name].freeze
    SUPPORTED_SORT_ORDER_VALUES = %w[asc desc].freeze

    DEFAULT_SORT_DIR = "name"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.products = Product.all.with_translations(I18n.locale)

      filter_products
      sort_products

      paginate_products
    end

    private

    def filter_products
      return if context.filter.blank?

      if context.filter[:resource_type_id].present?
        context.products = products.where(
          resource_type_id: context.filter[:resource_type_id]
        )
      end

      context.products = name_matches.or(description_matches) if context.filter[:q].present?
    end

    def sort_products
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_name if context.sort_by == "name"
    end

    def sort_by_name
      context.products = context.products.order("product_translations.name": context.sort_order.to_sym)
    end

    def name_matches
      context.products.where("LOWER(product_translations.name) LIKE ?", "%#{context.filter[:q]}%")
    end

    def description_matches
      context.products.where("LOWER(product_translations.description) LIKE ?", "%#{context.filter[:q]}%")
    end

    def paginate_products
      context.products = context.products.page(context.page)
    end
  end
end
