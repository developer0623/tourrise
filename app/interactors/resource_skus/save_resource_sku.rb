# frozen_string_literal: true

module ResourceSkus
  class SaveResourceSku
    include Interactor

    def call
      context.fail!(message: "resource sku context missing") unless context.resource_sku.present?

      fail_with_context unless context.resource_sku.save
    rescue ActiveRecord::RecordNotUnique
      context.fail!(message: "resource sku already exists")
    end

    def rollback
      context.resource_sku.destroy if context.destroy_on_rollback
    end

    private

    def fail_with_context
      context.fail!(message: context.resource_sku.errors.full_messages)
    end
  end
end
