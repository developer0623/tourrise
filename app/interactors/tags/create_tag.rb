# frozen_string_literal: true

module Tags
  class CreateTag
    include Interactor

    def call
      context.tag = Tag.new(create_params)

      add_tag_group

      context.fail!(message: context.tag.errors.full_messages) unless context.tag.save
    end

    private

    def create_params
      context.params.slice("name", "handle")
    end

    def add_tag_group
      return context.tag.tag_group_id = context.params["tag_group_id"] if context.params["tag_group_id"].present?

      return if context.params["tag_group_name"].blank?

      tag_group = TagGroup.find_or_initialize_by(name: context.params["tag_group_name"])
      context.tag.tag_group = tag_group
    end
  end
end
