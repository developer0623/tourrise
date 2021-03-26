# frozen_string_literal: true

module Easybill
  class BookingCanceledHandler
    def self.handle(data)
      CancelInvoicesJob.perform_later(data)
    end
  end
end
