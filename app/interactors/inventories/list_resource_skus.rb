# frozen_string_literal: true

module Inventories
  class ListResourceSkus
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      name
      handle
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "name"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.resource_skus = Inventory.find(context.inventory_id).resource_skus

      sort_resource_skus

      context.resource_skus = context.resource_skus.page(context.page)
    end

    private

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
      sort_by_handle if context.sort_by == "handle"
    end

    def sort_by_name
      context.resource_skus = context.resource_skus.order(name: context.sort_order)
    end

    def sort_by_handle
      context.resource_skus = context.resource_skus.order(handle: context.sort_order)
    end
  end
end
