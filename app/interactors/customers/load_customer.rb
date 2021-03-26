# frozen_string_literal: true

module Customers
  class LoadCustomer
    include Interactor

    def call
      customer = Customer.find_by(
        id: context.customer_id
      )

      context.fail!(message: :not_found) unless customer.present?

      CustomAttribute.where.not(id: customer.custom_attribute_ids).each do |custom_attribute|
        customer.custom_attribute_values.new(custom_attribute: custom_attribute)
      end

      context.customer = customer
    end
  end
end
