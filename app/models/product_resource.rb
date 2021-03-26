# frozen_string_literal: true

class ProductResource < ApplicationRecord
  belongs_to :product
  belongs_to :resource
end
