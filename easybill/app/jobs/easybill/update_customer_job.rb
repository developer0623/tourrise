# frozen_string_literal: true

module Easybill
  class UpdateCustomerJob < EasybillJob
    def perform(customer_data)
      UpdateCustomer.call(data: customer_data)
    end
  end
end
