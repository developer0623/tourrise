# frozen_string_literal: true

class CustomAttributeValue < ApplicationRecord
  belongs_to :custom_attribute
  belongs_to :attributable, polymorphic: true

  validates :custom_attribute_id, uniqueness: { scope: %i[attributable_id attributable_type] }

  delegate :name, :field_type, to: :custom_attribute
end
