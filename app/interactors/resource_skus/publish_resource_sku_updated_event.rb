# frozen_string_literal: true

module ResourceSkus
  class PublishResourceSkuUpdatedEvent
    include Interactor

    def call
      PublishEventJob.perform_later(Event::RESOURCE_SKU_UPDATED, context.resource_sku)
    end
  end
end
