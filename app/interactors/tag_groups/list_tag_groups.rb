# frozen_string_literal: true

module TagGroups
  class ListTagGroups
    include Interactor

    def call
      context.tag_groups = TagGroup.all

      filter_tag_groups
      sort_tag_groups
    end

    private

    def filter_tag_groups
      return if context.filter.blank?

      context.tag_groups = context.tag_groups.where("name LIKE ?", "%#{context.filter['q']}%") if context.filter["q"].present?
    end

    def sort_tag_groups
      context.tag_groups = context.tag_groups.order(:name)
    end
  end
end
