# frozen_string_literal: true

module Easybill
  class CreateOfferJob < EasybillJob
    def perform(offer_data)
      context = CreateOffer.call(data: offer_data)

      return true if context.success?

      raise "CreateOffer failed with: #{context.error}" unless context.error == :easybill_customer_not_created

      create_customer(context.booking)
      retry_later(offer_data)
    end

    private

    def create_customer(booking)
      CreateCustomerJob.perform_later(
        booking.customer.as_json(only: %i[id])
      )
    end

    def retry_later(offer_data)
      self.class.set(wait: 5.seconds).perform_later(offer_data)
    end
  end
end
