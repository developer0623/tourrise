# frozen_string_literal: true

module Easybill
  class CreatePositionJob < EasybillJob
    def perform(resource_sku_data)
      CreatePosition.call(data: resource_sku_data)
    end
  end
end
