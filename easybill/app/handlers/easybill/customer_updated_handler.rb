# frozen_string_literal: true

module Easybill
  class CustomerUpdatedHandler
    def self.handle(customer_data)
      UpdateCustomerJob.perform_later(customer_data)
    end
  end
end
