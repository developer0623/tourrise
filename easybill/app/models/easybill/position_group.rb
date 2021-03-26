# frozen_string_literal: true

module Easybill
  class PositionGroup < ApplicationRecord
    belongs_to :resource

    has_many :positions

    validates :external_id, :resource_id, presence: true
  end
end
