# frozen_string_literal: true

module Easybill
  class BookingInvoiceCreatedHandler
    def self.handle(data)
      CreateInvoiceJob.perform_later(data)
    end
  end
end
