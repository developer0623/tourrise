# frozen_string_literal: true

module Easybill
  class CustomerCreatedHandler
    def self.handle(customer_data)
      CreateCustomerJob.perform_later(customer_data)
    end
  end
end
