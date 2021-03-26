# frozen_string_literal: true

module Frontoffice
  class InitializeBookingForm
    include Interactor

    before :load_product_sku
    before :reset_form_progression

    def call
      context.booking_form = initialize_booking_form
    end

    private

    def load_product_sku
      LoadProductSku.call!(context)
    end

    def initialize_booking_form
      form_klazz.new(
        product_sku_id: context.product_sku.id,
        creator_id: FrontofficeUser.id,
        booking: Booking.new(product_sku: context.product_sku),
        title: BookingTitle.from_product_sku(context.product_sku),
        adults: 1
      )
    end

    def form_klazz
      @form_klazz ||= "Frontoffice::Booking#{step_handle.classify}Form".constantize
    end

    def step_handle
      context.product_sku.product.product_frontoffice_steps.first.handle
    end

    def reset_form_progression
      context.session.delete(:latest_frontoffice_step)
    end
  end
end
