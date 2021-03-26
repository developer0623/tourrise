require "rails_helper"

RSpec.describe "Customer api", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:customer) { FactoryBot.create(:customer) }

  before do
    travel_to Time.zone.local(2020,10,10,10,10,10)
    customer.save
    sign_in(user)
  end

  after do
    travel_back
  end

  it "returns the customer as json" do
    customer.save

    visit "/api/customers/#{customer.id}.json"

    customer_data = JSON.parse(page.body)

    expected_data = {
      "data"=> {
        "id" => "#{customer.id}",
        "type" => "customers",
        "attributes" => {
          "id" => customer.id,
          "title" => nil,
          "first_name" => customer.first_name,
          "last_name" => customer.last_name,
          "gender" => nil,
          "country" => nil,
          "state" => nil,
          "zip" => nil,
          "address_line_1" => nil,
          "address_line_2" => nil,
          "city" => nil,
          "locale" => customer.locale,
          "email" => customer.email,
          "birthdate" => "1995-10-10",
          "primary_phone" => "123740",
          "secondary_phone" => "239448",
          "participant_type" => "adult",
          "created_at" => "2019-10-10T10:10:10.000+02:00",
          "updated_at" => "2020-10-10T10:10:10.000+02:00",
          "full_name" => "John Doe",
          "full_address" => " ",
          "localized_birthdate" => "10. Oktober 1995",
          "bookings_count" => I18n.t("customers.index.bookings_count", count: customer.bookings.count)
        },
        "links"=>{ "self" => "/de/customers/#{customer.id}" }
      }, "jsonapi"=>{ "version" => "1.0" }
    }

    expect(customer_data).to eq(expected_data)
  end

  context "with fields" do
    it "contains the requested fields" do
      visit "/api/customers/#{customer.id}.json?fields=id,localized_birthdate"

      customer_data = JSON.parse(page.body)

      expected_data = {
        "data"=> {
          "id" => "#{customer.id}",
          "type" => "customers",
          "attributes"=> {
            "id" => customer.id,
            "localized_birthdate" => "10. Oktober 1995"
          },
          "links"=>{ "self" => "/de/customers/#{customer.id}" }
        }, "jsonapi"=>{ "version" => "1.0" }
      }

      expect(customer_data).to eq(expected_data)
    end
  end

  context "when the customer does not exist" do
    it "renders a not found error as json" do
      visit "/api/customers/unknown.json?fields=id,localized_birthdate"

      error_data = JSON.parse(page.body)

      expect(error_data).to eq({
        "error" => {
          "code" => 404,
          "message" => "not_found"
        }
      })
    end
  end
end
