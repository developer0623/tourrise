# frozen_string_literal: true

class ResourceSku < ApplicationRecord
  belongs_to :resource

  validates :name, :handle, :resource, presence: true

  def price; end
  def purchase_price; end
  def calculation_type; end
end
