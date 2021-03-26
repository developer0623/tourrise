# frozen_string_literal: true

module Customers
  class UpdateCustomer
    include Interactor

    after do
      PublishEventJob.perform_later(Event::CUSTOMER_UPDATED, context.customer)
    end

    def call
      context.customer = Customer.find(context.customer_id)

      context.fail!(message: context.customer.errors.full_messages) unless context.customer.update(context.params)
    end
  end
end
