# frozen_string_literal: true

module Customers
  class ImportCustomersJob < ApplicationJob
    def perform
      load_customers
    end

    private

    def load_customers
      CSV.foreach(
        Rails.root.join("db", "data", "customers.csv"),
        headers: true,
        header_converters: %i[symbol downcase]
      ) do |row|
        next unless row[:email].present?

        context = CreateCustomer.call(
          params: {
            title: row[:title],
            first_name: row[:first_name],
            last_name: row[:last_name],
            primary_phone: row[:primary_phone],
            secondary_phone: row[:secondary_phone],
            email: row[:email],
            gender: row[:gender],
            address_line_1: row[:address_line_1],
            address_line_2: row[:address_line_2],
            zip: row[:zip],
            city: row[:city],
            state: row[:state],
            country: row[:country],
            birthdate: row[:birthdate]
          },
          skip_publish: true
        )

        if context.success?
          Easybill::Customer.create(customer: context.customer, external_id: row[:external_id])
        else
          Rails.logger.warn(context.message)
        end
      end
    end
    # rubocop:enable
  end
end
