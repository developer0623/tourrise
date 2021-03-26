# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::BookingResourceSkuGroupMapper do
  subject { described_class.new(mapper_params).call }

  let(:mapper_params) do
    { booking: booking, booking_resource_sku_group: booking_resource_sku_group, document: document }
  end

  let(:document) { instance_double(BookingOffer, booking_resource_skus_snapshot: booking_resource_skus) }
  let(:booking_resource_skus) { [JSON.parse(File.read("easybill/spec/fixtures/booking_resource_sku_snapshot.json"))] }
  let(:starts_on) { Date.new(2019, 10, 10) }
  let(:ends_on) { Date.new(2019, 10, 12) }
  let(:booking) { instance_double(Booking, starts_on: starts_on, ends_on: ends_on) }
  let(:booking_resource_sku_group) do
    JSON.parse(File.read("easybill/spec/fixtures/booking_resource_sku_group_snapshot.json"))
  end
  let(:expected_mapping) do
    [
      {
        description: "Resource Sku Group name",
        quantity: 1,
        vat_percent: "10.0",
        single_price_net: 9.09090909090909,
        booking_account: "3333",
        export_cost_1: "10"
      },
      [
        {
          type: "TEXT",
          description: <<~eos.gsub(/\n/, '').chomp
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         Resource name - What a cool resource sku<br/>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;John Doe<br/>
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;John Doe
                       eos
        },
        {
          type: "TEXT",
          description: "<table style=\"width: 100%;\">" \
                          "<thead>" \
                            "<tr><th style=\"width: 45%\"> Abflug</th><th style=\"width: 45%\"> Ankunft</th><th style=\"width: 10%\"> Flugnr.</th></tr>" \
                          "</thead>" \
                          "<tbody>" \
                            "<tr><td>  26.11.2020, 13:32 Uhr Frankfurt am Main Airport</td><td>  26.11.2020, 13:32 Uhr Ellison Onizuka Kona International At Keahole Airport</td><td>  UA0911</td></tr>" \
                            "<tr><td>  26.11.2020, 13:32 Uhr Frankfurt am Main Airport</td><td>  26.11.2020, 13:32 Uhr Ellison Onizuka Kona International At Keahole Airport</td><td>  UA0911</td></tr>" \
                          "</tbody>" \
                       "</table>"
        }
      ]
    ]
  end

  describe "#call" do
    context "data is correct" do
      it { is_expected.to eq(expected_mapping) }
    end
  end
end
