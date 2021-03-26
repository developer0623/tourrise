# frozen_string_literal: true

module Inventories
  class ListInventories
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      name
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "name"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.inventories = Inventory.all

      filter_products
      sort_inventories

      paginate_inventories
    end

    def filter_products
      return if context.filter.blank?

      context.inventories = name_matches.or(description_matches) if context.filter[:q].present?
    end

    def sort_inventories
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_column
    end

    def sort_by_column
      sort_by_name if context.sort_by == "name"
    end

    def sort_by_name
      context.inventories = context.inventories.order(name: context.sort_order)
    end

    def name_matches
      context.inventories.where("LOWER(inventories.name) LIKE ?", "%#{context.filter[:q]}%")
    end

    def description_matches
      context.inventories.where("LOWER(inventories.description) LIKE ?", "%#{context.filter[:q]}%")
    end

    def paginate_inventories
      context.inventories = context.inventories.page(context.page)
    end
  end
end
