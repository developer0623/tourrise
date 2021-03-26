# frozen_string_literal: true

module Resources
  class AssignResourceAttributes
    include Interactor

    def call
      context.fail!(message: "resource context missing") unless context.resource.present?

      context.resource.assign_attributes(permitted_params)
    end

    private

    def permitted_params
      context.fail!(message: "params context missing") unless context.params.present?

      context.params.slice(
        :name,
        :description,
        :teaser_text,
        :handle,
        :resource_type_id,
        :resource_skus_attributes
      )
    end
  end
end
