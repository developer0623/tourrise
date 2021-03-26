# frozen_string_literal: true

module ResourceSkus
  class PublishResourceSkuDeletedEvent
    include Interactor

    def call
      PublishEventJob.perform_later(Event::RESOURCE_SKU_DELETED, context.resource_sku)
    end
  end
end
