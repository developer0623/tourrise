# frozen_string_literal: true

class ResourceSkuInventory < ApplicationRecord
  belongs_to :inventory
  belongs_to :resource_sku
end
