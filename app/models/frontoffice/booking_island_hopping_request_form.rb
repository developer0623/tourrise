# frozen_string_literal: true

module Frontoffice
  class BookingIslandHoppingRequestForm < BookingResourceSkuRequestFormBase
    def island_hoppings
      resource_type_id = ResourceType.find_by(handle: :island_hopping)&.id

      product_sku.resources.where(resource_type_id: resource_type_id)
    end
  end
end
