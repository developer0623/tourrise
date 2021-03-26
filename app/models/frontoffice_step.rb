# frozen_string_literal: true

class FrontofficeStep < ApplicationRecord
  MANDATORY_STEPS = %w[request contact participants summary].freeze

  has_many :product_frontoffice_steps
  has_many :products, through: :product_frontoffice_steps

  validates :handle, uniqueness: { case_sensitive: false }, presence: true
  validates :position, presence: true

  default_scope { order(:position) }

  def self.mandatory
    where(handle: MANDATORY_STEPS)
  end

  def required?
    MANDATORY_STEPS.include?(handle)
  end

  def name
    I18n.t("booking_form.steps.#{read_attribute(:handle)}")
  end
end
