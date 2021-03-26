# frozen_string_literal: true

module Easybill
  class ResourceSkuUpdatedHandler
    def self.handle(resource_sku_data)
      UpdatePositionJob.perform_later(resource_sku_data)
    end
  end
end
