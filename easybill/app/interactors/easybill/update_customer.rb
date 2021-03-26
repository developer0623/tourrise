# frozen_string_literal: true

module Easybill
  class UpdateCustomer < InteractorBase
    def call
      load_easybill_customer
      load_backoffice_customer
      return unless contact_customer?

      update_customer

      context.easybill_customer.touch
    end

    private

    def load_easybill_customer
      easybill_customer = ::Easybill::Customer.find_by(customer_id: context.data["id"])
      context.fail!(message: "easybill sync customer does not exist") unless easybill_customer
      context.easybill_customer = easybill_customer
    end

    def load_backoffice_customer
      context.customer = ::Customer.find(context.data["id"])
    end

    def contact_customer?
      context.customer.bookings.any?
    end

    def update_customer
      easybill_customer_data = CustomerMapper.to_easybill_customer(context.customer)

      response = easybill_api_service.update_customer(context.easybill_customer.external_id, easybill_customer_data)

      raise "customer could not get updated: #{response.body}" unless response.success?
    end
  end
end
