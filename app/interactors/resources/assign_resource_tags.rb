# frozen_string_literal: true

module Resources
  class AssignResourceTags
    include Interactor

    before :steup_tags_context

    def call
      return if context.tags.nil?

      context.fail!(message: "resource context missing") unless context.resource.present?

      context.resource.tags = parse_tags
    end

    private

    def steup_tags_context
      context.tags = context.params.delete(:tags)
    end

    def parse_tags
      tags = context.tags.presence ? JSON.parse(context.tags) : []
      handles = tags.map do |tag|
        tag["code"]
      end

      Tag.where(handle: handles)
    end
  end
end
