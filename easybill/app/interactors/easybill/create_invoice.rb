# frozen_string_literal: true

module Easybill
  class CreateInvoice < InteractorBase
    before do
      load_booking
      load_booking_invoice
      easybill_customer_exists?
    end

    after do
      SavePdfJob.perform_later(context.booking, context.booking_invoice, context.invoice.external_id) if context.invoice.persisted?
    end

    def call
      easybill_document_data = BookingMapper.to_easybill_document(context.booking, context.booking_invoice, type: type)

      easybill_document = create_easybill_invoice(easybill_document_data)

      context.invoice = Invoice.create!(booking_invoice_id: context.data["id"],
                                        external_id: easybill_document["id"],
                                        external_number: easybill_document["number"])
    end

    private

    def load_booking
      context.booking = Booking.find(context.data["booking_id"])
    end

    def load_booking_invoice
      context.booking_invoice = BookingInvoice.find(context.data["id"])
    end

    def create_easybill_invoice(document_data)
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

    def type
      return "ADVANCE_INVOICE" if context.booking_invoice.type == AdvanceBookingInvoice.model_name.name

      "INVOICE"
    end
  end
end
