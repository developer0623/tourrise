# frozen_string_literal: true

module Resources
  class ListResources
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      resource_type_name
      name
      resource_skus_count
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "name"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.resources = Resource.with_translations(I18n.locale).includes(:images_attachments, :resource_type)

      filter_resources
      sort_resources

      context.resources = context.resources.page(context.page)
    end

    private

    def filter_resources
      return if context.filter.blank?

      if context.filter[:resource_type_id].present?
        context.resources = context.resources.where(
          resource_type_id: context.filter[:resource_type_id]
        )
      end

      context.resources = name_matches.or(description_matches) if context.filter[:q].present?
    end

    def sort_resources
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_column
    end

    def sort_by_column
      sort_by_resource_type_name if context.sort_by == "resource_type_name"
      sort_by_name if context.sort_by == "name"
      sort_by_resource_skus_count if context.sort_by == "resource_skus_count"
    end

    def sort_by_resource_type_name
      context.resources = context.resources.order("resource_types.label #{context.sort_order}")
    end

    def sort_by_name
      context.resources = context.resources.order("resource_translations.name": context.sort_order)
    end

    def sort_by_resource_skus_count
      context.resources = context.resources.left_joins(:resource_skus).group(:id).order("COUNT(resource_skus.id) #{context.sort_order}")
    end

    def name_matches
      context.resources.where("LOWER(resource_translations.name) LIKE ?", "%#{context.filter[:q]}%")
    end

    def description_matches
      context.resources.where("LOWER(resource_translations.description) LIKE ?", "%#{context.filter[:q]}%")
    end
  end
end
