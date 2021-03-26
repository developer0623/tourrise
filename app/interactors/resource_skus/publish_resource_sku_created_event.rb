# frozen_string_literal: true

module ResourceSkus
  class PublishResourceSkuCreatedEvent
    include Interactor

    def call
      PublishEventJob.perform_later(Event::RESOURCE_SKU_CREATED, context.resource_sku)
    end
  end
end
