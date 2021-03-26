# frozen_string_literal: true

module Easybill
  class SavePdf < InteractorBase
    def call
      response_pdf = easybill_api_service.download_document(context.document_id)

      if response_pdf.success?
        filename = "#{context.attachable.class.name.underscore}_#{context.document_id}.pdf"
        context.attachable.pdf.attach(io: StringIO.new(response_pdf.body),
                                      filename: filename,
                                      content_type: "application/pdf")
      else
        context.fail!(message: response_pdf.body)
      end
    end

    private

    def employee
      ::Easybill::Employee.find_by(user_id: context.booking.assignee_id)
    end

    def easybill_api_service
      @easybill_api_service ||= ApiService.new(api_key: employee&.api_key)
    end
  end
end
