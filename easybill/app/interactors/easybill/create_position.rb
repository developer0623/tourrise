# frozen_string_literal: true

module Easybill
  class CreatePosition < InteractorBase
    def call
      return if position_exists?

      easybill_position_data = ResourceSkuMapper.to_easybill_position(resource_sku)

      easybill_position = create_easybill_position(easybill_position_data)

      context.position = Position.create!(
        resource_sku_id: resource_sku.id,
        external_id: easybill_position["id"]
      )
    end

    private

    def position_exists?
      Position.find_by(resource_sku_id: context.data["id"])
    end

    def resource_sku
      @resource_sku ||= ::ResourceSku.find(context.data["id"])
    end

    def create_easybill_position(position_data)
      response = easybill_api_service.create_position(position_data)
      context.fail!(message: response) unless response.success?

      response
    end
  end
end
