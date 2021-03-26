# frozen_string_literal: true

module Easybill
  class CreateCustomer < InteractorBase
    before do
      validate
    end

    def call
      load_customer
      return unless contact_customer?

      response = create_easybill_customer

      ::Easybill::Customer.create!(customer: context.customer, external_id: response["id"])
    end

    private

    def validate
      context.fail!(message: "customer already synced") if find_easybill_customer
    end

    def contact_customer?
      context.customer.bookings.any?
    end

    def load_customer
      context.customer = ::Customer.find(context.data["id"])
    end

    def find_easybill_customer
      ::Easybill::Customer.find_by(customer_id: context.data["id"])
    end

    def create_easybill_customer
      easybill_customer_data = CustomerMapper.to_easybill_customer(context.customer)

      response = easybill_api_service.create_customer(easybill_customer_data)

      raise "customer could not get created: #{response.body}" unless response.success?

      response
    rescue StandardError => e
      Rails.logger.info easybill_customer_data
      raise e
    end
  end
end
