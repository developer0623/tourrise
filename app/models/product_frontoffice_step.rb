# frozen_string_literal: true

class ProductFrontofficeStep < ApplicationRecord
  belongs_to :product
  belongs_to :frontoffice_step

  validates :product_id, uniqueness: { scope: :frontoffice_step_id }

  delegate :handle, :position, to: :frontoffice_step

  default_scope { joins(:frontoffice_step).order(:position) }

  def next_step
    product.frontoffice_steps.where("position > ?", position).first
  end

  def previous_step
    return if position == 1

    product.frontoffice_steps.where("position < ?", position).last
  end
end
