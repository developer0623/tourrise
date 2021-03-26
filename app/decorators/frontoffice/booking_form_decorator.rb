# frozen_string_literal: true

module Frontoffice
  class BookingFormDecorator < Draper::Decorator
    delegate_all

    decorates_association :booking, with: Frontoffice::BookingDecorator

    def steps
      object.product.frontoffice_steps
    end

    def next_step_path
      h.edit_frontoffice_booking_path(
        booking_id,
        step: next_step_handle
      )
    end

    def booking_id
      object.booking.scrambled_id
    end

    def product_sku_handle
      object.product_sku.handle
    end

    def product_name
      object.product_sku&.product&.name
    end

    def product_description
      object.product_sku&.product&.description
    end

    def with_kids?
      object.booking.kids.to_i.positive?
    end

    def with_babies?
      object.booking.babies.to_i.positive?
    end

    def people_count
      object.booking.people_count
    end

    def current_step
      object.product.product_frontoffice_steps.find_by(frontoffice_steps: { handle: current_step_handle })
    end

    def current_step_number
      object.product.product_frontoffice_steps.pluck(:frontoffice_step_id).find_index(current_step.frontoffice_step_id).to_i + 1
    end

    def next_step_handle
      current_step.next_step.handle
    end

    def current_step_handle
      raise "not implemented"
    end

    def configured_starts_on
      seasonal_starts_on = object.product_sku.current_active_seasonal_product_sku&.starts_on
      return Date.tomorrow unless seasonal_starts_on.present?

      seasonal_starts_on < Date.today ? Date.tomorrow : seasonal_starts_on
    end

    def configured_ends_on
      seasonal_ends_on = object.product_sku.current_active_seasonal_product_sku&.ends_on
      return 2.days.from_now.to_date unless seasonal_ends_on.present?

      seasonal_ends_on.today? ? 2.days.from_now.to_date : seasonal_ends_on
    end
  end
end
