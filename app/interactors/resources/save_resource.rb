# frozen_string_literal: true

module Resources
  class SaveResource
    include Interactor

    def call
      context.fail!(message: "resource context missing") unless context.resource.present?

      fail_with_context unless context.resource.save
    rescue ActiveRecord::RecordNotUnique
      context.fail!(message: "resource sku already exists")
    end

    def rollback
      context.resource.destroy if context.destroy_on_rollback
    end

    private

    def fail_with_context
      context.fail!(message: context.resource.errors.full_messages)
    end
  end
end
