require "rails_helper"

RSpec.describe "Api V1 Booking Invoices", type: :request do
  let(:user) { create(:user) }

  let(:booking) { create(:booking) }
  let(:booking_invoice) { create(:booking_invoice, booking: booking) }

  before do
    travel_to Time.zone.local(2020,10,10,10,10,10)

    booking_invoice

    sign_in(user)
  end

  after do
    travel_back
  end

  it 'returns the data' do
    get api_v1_booking_invoices_path(format: :json, locale: I18n.locale)

    parsed_json = JSON.parse(response.body)

    expect(parsed_json).to have_key("data")
  end

  it 'returns the included models' do
    get api_v1_booking_invoices_path(format: :json, locale: I18n.locale)

    parsed_json = JSON.parse(response.body)

    expect(parsed_json).to have_key("included")
  end

  it 'returns the meta data' do
    get api_v1_booking_invoices_path(format: :json, locale: I18n.locale)

    parsed_json = JSON.parse(response.body)

    expect(parsed_json).to have_key("meta")
  end
end
