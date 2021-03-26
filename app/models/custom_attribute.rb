# frozen_string_literal: true

class CustomAttribute < ApplicationRecord
  translates :name, fallbacks_for_empty_translations: true

  has_many :custom_attribute_values, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  enum field_type: %i[text date number email]
end
