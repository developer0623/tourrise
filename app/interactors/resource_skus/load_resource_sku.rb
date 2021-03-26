# frozen_string_literal: true

module ResourceSkus
  class LoadResourceSku
    include Interactor

    def call
      resource_sku = ResourceSku.find_by_id(context.resource_sku_id)
      context.fail!(message: "Resource Sku not found.") unless resource_sku.present?

      context.resource_sku = resource_sku
    end
  end
end
