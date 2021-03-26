# frozen_string_literal: true

module Frontoffice
  class CreateBookingForm
    include Interactor

    before :load_product_sku
    before :load_step
    before :initialize_booking_form

    def call
      context.booking_form.assign_attributes(context.params)

      context.fail!(message: context.booking_form.booking.errors.full_messages) unless context.booking_form.save
    end

    private

    def load_product_sku
      LoadProductSku.call!(context)
    end

    def initialize_booking_form
      InitializeBookingForm.call(context)
    end

    def load_step
      return context.step if context.step.present?

      context.step = context.product_sku.product.product_frontoffice_steps.first
    end
  end
end
