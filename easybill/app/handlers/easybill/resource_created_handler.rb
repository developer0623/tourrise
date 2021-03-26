# frozen_string_literal: true

module Easybill
  class ResourceCreatedHandler
    def self.handle(resource_data)
      CreatePositionGroupJob.perform_later(resource_data)
    end
  end
end
