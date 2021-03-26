# frozen_string_literal: true

module Customers
  class CreateCustomer
    include Interactor

    after do
      PublishEventJob.perform_later(Event::CUSTOMER_CREATED, context.customer)
    end

    def call
      context.customer = Customer.new(context.params)

      context.fail!(message: context.customer.errors) unless context.customer.save

      context.fail!(message: I18n.t("customers.create.general_id_error")) unless context.customer.update_attribute(:general_customer_id, GeneralCustomerId.next(context.customer))
    end
  end
end
