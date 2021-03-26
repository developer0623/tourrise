# frozen_string_literal: true

module Easybill
  class Position < ApplicationRecord
    belongs_to :resource_sku
    belongs_to :position_group, optional: true

    validates :external_id, :resource_sku_id, presence: true
  end
end
