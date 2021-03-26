# frozen_string_literal: true

class OccupationConfiguration < ApplicationRecord
  has_many :resource_skus

  def occupiable_with_count?(number)
    (min_occupancy..max_occupancy).cover?(number)
  end

  def occupiable_by_adults_count?(number)
    (min_adults..max_adults).cover?(number)
  end

  def occupiable_by_kids_count?(number)
    (min_kids..max_kids).cover?(number)
  end

  def occupiable_by_babies_count?(number)
    (min_babies..max_babies).cover?(number)
  end
end
