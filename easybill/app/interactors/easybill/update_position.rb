# frozen_string_literal: true

module Easybill
  class UpdatePosition < InteractorBase
    def call
      easybill_position_data = ResourceSkuMapper.to_easybill_position(resource_sku)

      update_easybill_position(easybill_position_data)

      context.position = position.touch
    end

    private

    def position
      return @position if defined?(@position)

      @position = Position.find_by(resource_sku_id: context.data["id"])

      context.fail!(message: :not_found) unless @position.present?

      @position
    end

    def resource_sku
      @resource_sku ||= ::ResourceSku.find(context.data["id"])
    end

    def update_easybill_position(position_data)
      response = easybill_api_service.update_position(position.external_id, position_data)
      context.fail!(message: response) unless response.success?

      response
    end
  end
end
