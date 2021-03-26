# frozen_string_literal: true

module Easybill
  class CustomerMapper
    def self.to_easybill_customer(customer)
      data = {
        title: customer.title,
        first_name: customer.first_name,
        last_name: customer.last_name,
        salutation: easybill_salutation(customer.gender),
        birth_date: customer.birthdate,
        emails: [customer.email],
        phone_1: customer.primary_phone,
        phone_2: customer.secondary_phone,
        street: customer.address_line_1,
        zip_code: customer.zip,
        city: customer.city,
        since_date: customer.created_at,
        info_2: "Backoffice ID: #{customer.id}"
      }

      data[:country] = easybill_country(customer.country) if customer.country.present?
      data[:company_name] = customer.company_name if customer.company_name.present?

      data
    end

    def self.easybill_salutation(gender)
      return 0 unless gender
      return 1 if gender == "male"
      return 2 if gender == "female"
    end

    def self.easybill_country(country)
      case country
      when "EN", "GB"
        "UK"
      when "BQ"
        "NL"
      when "SS"
        "SD"
      else
        country
      end
    end
  end
end
