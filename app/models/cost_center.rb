# frozen_string_literal: true

class CostCenter < ApplicationRecord
  validates :name, :value, presence: true

  def display_name
    "#{name} (#{value})"
  end
end
