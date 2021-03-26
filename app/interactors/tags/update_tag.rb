# frozen_string_literal: true

module Tags
  class UpdateTag
    include Interactor

    def call
      context.tag = Tag.find_by(id: context.tag_id)

      context.fail!(message: :not_found) if context.tag.blank?

      context.tag.assign_attributes(update_params)

      update_tag_group

      context.fail!(message: context.tag.errors.full_messages) unless context.tag.save
    end

    private

    def update_params
      context.params.slice("name", "handle")
    end

    def update_tag_group
      if context.params["tag_group_name"].present?
        tag_group = TagGroup.find_or_initialize_by(name: context.params["tag_group_name"])
        context.tag.tag_group = tag_group

        return
      end

      context.tag.tag_group_id = context.params["tag_group_id"]
    end
  end
end
