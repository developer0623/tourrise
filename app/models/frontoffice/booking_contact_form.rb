# frozen_string_literal: true

module Frontoffice
  class BookingContactForm < BookingFormBase
    FORM_FIELDS = %w[
      customer_attributes
    ].freeze

    attr_accessor(*FORM_FIELDS)

    def save
      if booking.customer.present? && booking.customer.persisted?
        update_customer
      else
        create_customer
      end

      update_first_participant

      booking.errors.blank?
    end

    def update_first_participant
      first_participant = booking.participants.first
      return unless first_participant.present?

      first_participant.update(
        first_name: booking.customer.first_name,
        last_name: booking.customer.last_name,
        email: booking.customer.email,
        birthdate: booking.customer.birthdate
      )
    end

    private

    def create_customer
      context = Customers::CreateCustomer.call(params: customer_attributes)

      if context.success?
        booking.update_attribute(:customer, context.customer)
      else
        booking.errors.add(:customer, context.message)
        booking.customer = context.customer
      end
    end

    def update_customer
      context = Customers::UpdateCustomer.call(customer_id: booking.customer_id, params: customer_attributes)

      return if context.success?

      booking.errors.add(:customer, context.message)
      booking.customer = context.customer
    end
  end
end
