# frozen_string_literal: true

module Resources
  class PublishResourceUpdatedEvents
    include Interactor

    def call
      context.fail!(message: "resource context missing") unless context.resource.present?

      PublishEventJob.perform_later(Event::RESOURCE_UPDATED, context.resource)

      context.resource.resource_skus.each do |resource_sku|
        publish_resource_sku_event(resource_sku)
      end
    end

    private

    def publish_resource_sku_event(resource_sku)
      if resource_sku.id_previously_changed?
        ResourceSkus::PublishResourceSkuCreatedEvent.call!(resource_sku: resource_sku)
      else
        ResourceSkus::PublishResourceSkuUpdatedEvent.call!(resource_sku: resource_sku)
      end
    end
  end
end
