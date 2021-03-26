# frozen_string_literal: true

module Easybill
  class ResourceSkuCreatedHandler
    def self.handle(resource_sku_data)
      CreatePositionJob.perform_later(resource_sku_data)
    end
  end
end
