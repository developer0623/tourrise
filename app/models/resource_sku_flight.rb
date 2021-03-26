# frozen_string_literal: true

class ResourceSkuFlight < ApplicationRecord
  belongs_to :resource_sku
  belongs_to :flight
end
