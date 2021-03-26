# frozen_string_literal: true

class NullPrice
  def self.present?
    false
  end

  def self.price
    0
  end
end
