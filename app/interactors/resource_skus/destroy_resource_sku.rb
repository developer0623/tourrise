# frozen_string_literal: true

module ResourceSkus
  class DestroyResourceSku
    include Interactor

    before do
      LoadResourceSku.call!(context)
    end

    after do
      PublishResourceSkuDeletedEvent.call!(context)
    end

    def call
      context.fail!(message: context.resource_sku.errors.full_messages) unless context.resource_sku.destroy
    end
  end
end
