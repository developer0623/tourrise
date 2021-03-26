# frozen_string_literal: true

module Easybill
  class SavePdfJob < EasybillJob
    def perform(booking, attachable, document_id)
      context = SavePdf.call(booking: booking,
                             attachable: attachable,
                             document_id: document_id)

      return true if context.success?

      raise "SavePdf failed with: #{context.error}"
    end
  end
end
