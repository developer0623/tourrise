# frozen_string_literal: true

module Easybill
  class CreateOffer < InteractorBase
    DOCUMENT_TYPE = "OFFER"

    before do
      load_booking
      load_booking_offer
      easybill_customer_exists?
    end

    after do
      SavePdfJob.perform_later(context.booking, context.booking_offer, context.offer.external_id) if context.offer.persisted?
    end

    def call
      easybill_document_data = BookingMapper.to_easybill_document(context.booking, context.booking_offer, type: DOCUMENT_TYPE)

      easybill_document = create_easybill_offer(easybill_document_data)

      context.offer = Offer.create!(booking_offer_id: context.data["id"],
                                    external_id: easybill_document["id"],
                                    external_number: easybill_document["number"])
    end

    private

    def load_booking
      context.booking = Booking.find(context.data["booking_id"])
    end

    def load_booking_offer
      context.booking_offer = BookingOffer.find(context.data["id"])
    end

    def create_easybill_offer(document_data)
      response = easybill_api_service.create_document(document_data)
      context.fail!(message: response) unless response.success?
      response = easybill_api_service.complete_document(response["id"])
      context.fail!(message: response) unless response.success?

      response
    end

    def easybill_customer_exists?
      return if ::Easybill::Customer.find_by(customer_id: context.booking.customer_id)

      context.fail!(error: :easybill_customer_not_created)
    end

    def easybill_api_service
      @easybill_api_service ||= ApiService.new(api_key: employee&.api_key)
    end

    def employee
      ::Easybill::Employee.find_by(user_id: context.booking.assignee_id)
    end
  end
end
