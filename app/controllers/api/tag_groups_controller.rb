# frozen_string_literal: true

module Api
  class TagGroupsController < ApiController
    def index
      context = ::TagGroups::ListTagGroups.call(filter: list_params.to_h)

      if context.success?
        render jsonapi: context.tag_groups, fields: tag_group_fields
      else
        render json: { error: context.message }, status: 400
      end
    end

    private

    def tag_group_fields
      permitted_params = params.permit(:fields)
      return {} if permitted_params.fetch("fields", "").blank?

      {
        tag_groups: permitted_params.fetch("fields").split(",")
      }
    end
  end
end
