# frozen_string_literal: true

module Easybill
  class CreatePositionGroup < InteractorBase
    def call
      easybill_position_group_data = ResourceMapper.to_easybill_position_group(resource)

      easybill_position_group = create_easybill_position_group(easybill_position_group_data)

      context.position_group = ::Easybill::PositionGroup.create!(
        resource_id: resource.id,
        external_id: easybill_position_group["id"]
      )
    end

    private

    def resource
      @resource ||= Resource.find(context.data["id"])
    end

    def create_easybill_position_group(position_group_data)
      response = easybill_api_service.create_position_group(position_group_data)
      context.fail!(message: response) unless response.success?

      response
    end
  end
end
