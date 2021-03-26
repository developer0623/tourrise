# frozen_string_literal: true

module Resources
  class PublishResourceCreatedEvents
    include Interactor

    def call
      context.fail!(message: "resource context missing") unless context.resource.present?

      PublishEventJob.perform_later(Event::RESOURCE_CREATED, context.resource)

      context.resource.resource_skus.each do |resource_sku|
        ResourceSkus::PublishResourceSkuCreatedEvent.call!(resource_sku: resource_sku)
      end
    end
  end
end
