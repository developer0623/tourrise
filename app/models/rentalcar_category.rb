# frozen_string_literal: true

class RentalcarCategory
  ### Categories
  #
  # M: Mini
  # N: Mini Elite
  # E: Economy *
  # H: Economy Elite
  # C: Compact
  # D: Compact Elite
  # I: Intermediate
  # J: Intermediate Elite
  # S: Standard
  # R: Standard Elite
  # F: Fullsize
  # G: Fullsize Elite
  # P: Premium
  # U: Premium Elite
  # L: Luxury
  # W: Luxury Elite
  # O: Oversize
  # X: Special
  CATEGORY_CODES = %w[M N E H C D I J S R F G P U L W O X].freeze

  ### Types
  #
  # B: 2-3 Door
  # C: 2/4 Door
  # D: 4-5 Door
  # W: Wagon/Estate
  # V: Passenger Van
  # L: Limousine
  # S: Sport
  # T: Convertible
  # F: SUV
  # J: Open Air All Terrain
  # X: Special
  # P: Pick up Regular Cab
  # Q: Pick up Extended Cab
  # Z: Special Offer Car
  # E: Coupe
  # M: Monospace
  # R: Recreational Vehicle
  # H: Motor Home
  # Y: 2 Wheel Vehicle
  # N: Roadster
  # G: Crossover
  # K: Commercial Van/Truck
  TYPE_CODES = %w[B C D W V L S T F J X P Q Z E M R H Y N G K].freeze

  ### Trans / Driven wheels
  #
  # M: Manual (drive unspecified)
  # N: Manual 4WD
  # C: Manual AWD
  # A: Auto (drive unspecified)
  # B: Auto 4WD
  # D: Auto AWD
  TRANS_CODES = %w[M N C A B D].freeze

  ### Fuel / air-con
  #
  # R: Unspecified Fuel With Air
  # N: Unspecified Fuel NO Air
  # D: Diesel Air
  # Q: Diesel NO Air
  # H: Hybrid Air
  # I: Hybrid NO Air
  # E: Electric Air
  # C: Electric NO Air
  # L: LPG/Compressed Gas Air
  # S: LPG/Compressed Gas NO Air
  # A: Hydrogen Air
  # B: Hydrogen NO Air
  # M: Multi Fuel/Power Air
  # F: Multi Fuel/Power NO Air
  # V: Petrol Air
  # Z: Petrol NO Air
  # U: Ethanol Air
  # X: Ethanol NO Air
  FUEL_AIR_CON_CODES = %w[R N D Q H I E C L S A B M F V Z U X].freeze

  def self.translated_categories
    CATEGORY_CODES.map { |category_code| I18n.t("rentalcar_categories.category_codes.#{category_code}") }
  end

  def self.translated_types
    TYPE_CODES.map { |type_code| I18n.t("rentalcar_categories.type_codes.#{type_code}") }
  end

  def self.translated_trans
    TRANS_CODES.map { |trans_code| I18n.t("rentalcar_categories.trans_codes.#{trans_code}") }
  end

  def self.translated_fuel_options
    FUEL_AIR_CON_CODES.map { |fuel_code| I18n.t("rentalcar_categories.fuel_codes.#{fuel_code}") }
  end
end
