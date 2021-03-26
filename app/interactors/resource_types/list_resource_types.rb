# frozen_string_literal: true

module ResourceTypes
  class ListResourceTypes
    include Interactor

    def call
      resource_types = filter_resource_types(all_resource_types)
      resource_types = paginate_resource_types(resource_types)

      context.resource_types = resource_types
    end

    private

    def all_resource_types
      @all_resource_types ||= ResourceType.all.order(:label)
    end

    def filter_resource_types(resource_types)
      return resource_types if context.filter.blank?

      resource_types = label_matches(resource_types).or(handle_matches(resource_types)) if context.filter[:q].present?

      resource_types
    end

    def label_matches(resource_types)
      resource_types.where(ResourceType.arel_table[:label].lower.matches("%#{context.filter[:q]}%"))
    end

    def handle_matches(resource_types)
      resource_types.where(ResourceType.arel_table[:handle].lower.matches("%#{context.filter[:q]}%"))
    end

    def paginate_resource_types(resource_types)
      resource_types.page(context.page)
    end
  end
end
