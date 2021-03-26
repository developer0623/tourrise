# frozen_string_literal: true

module ResourceSkus
  class AssignResourceSkuAttributes
    include Interactor

    PERMITTED_PARAMS = %i[
      name
      description
      available
      handle
      vat
      inventory_ids
      occupation_configuration_id
      resource_sku_pricings_attributes
      allow_partial_payment
      flights_attributes
    ].freeze

    def call
      context.fail!(message: "resource sku context missing") unless context.resource_sku.present?

      context.resource_sku.assign_attributes(permitted_params)
    end

    private

    def permitted_params
      context.fail!(message: "params context missing") unless context.params.present?

      context.params.slice(*PERMITTED_PARAMS)
    end
  end
end
