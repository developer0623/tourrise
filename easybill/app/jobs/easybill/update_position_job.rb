# frozen_string_literal: true

module Easybill
  class UpdatePositionJob < EasybillJob
    def perform(resource_sku_data)
      context = UpdatePosition.call(data: resource_sku_data)

      return true if context.success?

      enqueue_create_position_job(resource_sku_data) if context.message == :not_found
    end

    private

    def enqueue_create_position_job(resource_sku_data)
      CreatePositionJob.perform_later(resource_sku_data)
    end
  end
end
