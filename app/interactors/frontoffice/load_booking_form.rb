# frozen_string_literal: true

module Frontoffice
  class LoadBookingForm
    include Interactor

    before :load_booking
    after :update_form_progression

    def call
      context.booking_form = form_klazz.initialize_from_booking(context.booking)
    end

    private

    def load_booking
      LoadBooking.call!(context)
    end

    def form_klazz
      @form_klazz ||= "Frontoffice::Booking#{step_handle.classify}Form".constantize
    end

    def step_handle
      return context.step_handle if context.step_handle.present?

      context.booking.product.product_frontoffice_steps.find_by(frontoffice_steps: { handle: context.step_handle })
    end

    def update_form_progression
      current_step = context.booking.product.product_frontoffice_steps.find_by(frontoffice_steps: { handle: context.step_handle }).frontoffice_step
      stored_step_position = context.session[:latest_frontoffice_step]&.fetch("position", 0).to_i

      context.session[:latest_frontoffice_step] = current_step.attributes.slice("name", "handle", "position").to_h if current_step.position > stored_step_position
    end

    def frontoffice_template
      context.booking.product.frontoffice_template
    end
  end
end
