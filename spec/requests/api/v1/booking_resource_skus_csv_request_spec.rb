require "rails_helper"

RSpec.describe "Booking Resource Skus csv export", type: :request do
  let(:user) { create(:user) }

  let(:customer) { create(:customer, first_name: "Max", last_name: "Mustermann") }
  let(:participant) { create(:participant, first_name: "Max", last_name: "Mitreisender") }
  let(:product) { create(:product, name: "A Trip") }
  let(:product_sku) { create(:product_sku, handle: "a_product_sku_handle", name: "A Sub Trip", product: product) }
  let(:season) { create(:season, name: "2022/2023") }
  let(:booking) { create(:booking, aasm_state: :booked, product_sku: product_sku, customer: customer, season: season) }

  let(:booking_resource_sku) do
    create(:booking_resource_sku,
      booking: booking,
      resource_snapshot: { "name" => "A Resource Name" },
      resource_sku_snapshot: { "name" => "A Resource Variant Name", "handle" => "resource-handle" },
      remarks: "remarks",
      price: Money.new(10000)
    )
  end

  let(:starts_on_value) { create(:booking_attribute_value, booking_resource_sku: booking_resource_sku, handle: :starts_on, value: 2.weeks.from_now, attribute_type: :date, name: "starts_on", booking_attribute: nil) }
  let(:ends_on_value) { create(:booking_attribute_value, booking_resource_sku: booking_resource_sku, handle: :ends_on, value: 4.weeks.from_now, attribute_type: :date, name: "ends_on", booking_attribute: nil) }

  before do
    travel_to Time.zone.local(2020,10,10,10,10,10)

    booking_resource_sku

    starts_on_value
    ends_on_value

    booking.participants = [participant]
    booking_resource_sku.participants = [participant]

    sign_in(user)
  end

  after do
    travel_back
  end

  it "has the csv media type" do
    get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale, filter: {})

    expect(response.media_type).to eq("text/csv")
  end

  it "has the correct header row" do
    get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale, filter: {})

    csv = CSV.parse(response.body, headers: true)

    expect(csv.headers).to eq(Api::V1::GenerateProductResourceSkusCsvExport::HEADERS)
  end

  it "returns the booking_resource_sku" do
    get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale)

    csv = CSV.parse(response.body)

    expect(csv.size).to eq(2)

    expect(csv.last).to eq(
      [
        booking.id.to_s,
        "booked",
        "Max",
        "Mitreisender",
        "2022/2023",
        "A Trip",
        "A Sub Trip",
        "2020-10-24",
        "2020-11-07",
        "A Resource Name",
        "A Resource Variant Name",
        "resource-handle",
        "100,00",
        "1",
        "100,00",
        "remarks",
        nil,
        nil
      ]
    )
  end

  context "with a reservation to an inventory" do
    let!(:reservation) { create(:reservation, :booked, booking_resource_sku: booking_resource_sku) }

    it "adds the reservation id and inventory name to the csv export" do
      get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale)

      csv = CSV.parse(response.body)

      expect(csv.size).to eq(2)

      expect(csv.last).to eq(
        [
          booking.id.to_s,
          "booked",
          "Max",
          "Mitreisender",
          "2022/2023",
          "A Trip",
          "A Sub Trip",
          "2020-10-24",
          "2020-11-07",
          "A Resource Name",
          "A Resource Variant Name",
          "resource-handle",
          "100,00",
          "1",
          "100,00",
          "remarks",
          reservation.id.to_s,
          reservation.availability.inventory.name
        ]
    )
    end
  end

  context "with ends on gt than the ends on of the booking resource sku" do
    it "does not return the booking resource sku" do
      get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale, ends_on: { operator: :gt, value: 5.weeks.from_now.iso8601 })

      csv = CSV.parse(response.body, headers: true)

      expect(csv.to_a.size).to eq(1)
    end
  end

  context "with ends on lt than the ends on of the booking resource sku" do
    it "does return the booking resource sku" do
      get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale, ends_on: { operator: :lt, value: 5.weeks.from_now.iso8601 })

      csv = CSV.parse(response.body, headers: true)

      expect(csv.to_a.size).to eq(2)
    end
  end

  context "when the booking is not booked" do
    let(:booking) { create(:booking, aasm_state: :in_progress, product_sku: product_sku, customer: customer, season: season) }

    it "returns only the header row" do
      get api_v1_booking_resource_skus_path(product_sku_handle: product_sku.handle, format: :csv, locale: I18n.locale)

      csv = CSV.parse(response.body, headers: true)

      expect(csv.to_a.size).to eq(1)
    end
  end
end
