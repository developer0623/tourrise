# frozen_string_literal: true

class ResourceSkuAvailability < ApplicationRecord
  belongs_to :resource_sku
  belongs_to :availability
end
