module Seeds
  class Customers
    def self.seed!
      return if Customer.any?

      pp "Seeding Customers"
      100.times do |_index|
        create_randomized_customer
      end
    end

    def self.create_randomized_customer
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.email("#{first_name}.#{last_name}")
      params = {
        first_name: first_name,
        last_name: last_name,
        gender: %w[male female].sample,
        birthdate: Faker::Date.birthday(18, 65),
        country: Faker::Address.country_code,
        state: Faker::Address.state,
        zip: Faker::Address.zip_code,
        address_line_1: Faker::Address.street_address,
        address_line_2: Faker::Address.secondary_address,
        city: Faker::Address.city,
        locale: %w[en de fr es].sample,
        email: email,
        primary_phone: Faker::PhoneNumber.phone_number,
        secondary_phone: Faker::PhoneNumber.cell_phone
      }
      ::Customers::CreateCustomer.call(params: params)
    end
  end
end
