# frozen_string_literal: true

module Frontoffice
  class BookingInsuranceRequestForm < BookingResourceSkuRequestFormBase
    def insurances
      product_sku.resources.with_resource_type(ResourceType.insurance)
    end
  end
end
