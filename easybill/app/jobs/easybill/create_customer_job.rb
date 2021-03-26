# frozen_string_literal: true

module Easybill
  class CreateCustomerJob < EasybillJob
    def perform(customer_data)
      CreateCustomer.call(data: customer_data)
    end
  end
end
