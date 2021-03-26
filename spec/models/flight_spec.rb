require 'rails_helper'

RSpec.describe Flight, type: :model do
  it { should have_many(:booking_resource_sku_flights) }
  it { should have_many(:booking_resource_skus) }

  it { should have_many(:resource_sku_flights) }
  it { should have_many(:resource_skus) }

  it { should validate_presence_of(:airline_code) }
  it { should validate_presence_of(:flight_number) }
  it { should validate_presence_of(:arrival_at) }
  it { should validate_presence_of(:arrival_airport) }
  it { should validate_presence_of(:departure_at) }
  it { should validate_presence_of(:departure_airport) }
end
