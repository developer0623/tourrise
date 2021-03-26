# frozen_string_literal: true

class ScrambledId
  def self.generate
    SecureRandom.hex(10)
  end
end
