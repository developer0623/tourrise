# frozen_string_literal: true

module Easybill
  class CreatePositionGroupJob < EasybillJob
    def perform(resource_data)
      context = CreatePositionGroup.call(data: resource_data)

      raise "create position group failed with error: #{context.message}" unless context.success?
    end
  end
end
