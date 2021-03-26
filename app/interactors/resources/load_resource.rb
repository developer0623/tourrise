# frozen_string_literal: true

module Resources
  class LoadResource
    include Interactor

    def call
      resource = Resource.find_by_id(context.resource_id)
      context.fail!(message: "Resource not found.") unless resource.present?

      context.resource = resource
    end
  end
end
