# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::BookingResourceSkuMapper do
  let(:starts_on) { Date.new(2019, 10, 10) }
  let(:ends_on) { Date.new(2019, 10, 12) }

  let(:product_sku) { instance_double('ProductSku', financial_account: nil, cost_center: nil) }
  let(:booking) do
    double(:booking, starts_on: starts_on, ends_on: ends_on, product_sku: product_sku)
  end
  let(:description) { 'Resource name - What a cool resource sku<br/>John Doe<br/>John Doe' }
  let(:text_items) do
    [
      {
        type:"TEXT",
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
  end

  let(:booking_resource_sku) do
    JSON.parse(File.read("easybill/spec/fixtures/booking_resource_sku_snapshot.json"))
  end

  let(:position_id) { :external_position_id }
  let(:position) do
    instance_double(Easybill::Position, external_id: position_id)
  end

  let(:expected_fin_account) { "3333" }
  let(:expected_cost_center) { "10" }
  let(:expected_mapping) do
    [
      {
        number: 'a-resource-sku',
        description: description,
        position_id: position_id,
        quantity: 2,
        vat_percent: "19.0",
        export_cost_1: expected_cost_center,
        booking_account: expected_fin_account,
        single_price_net: 10.0 / 1.19
      }, text_items
    ]
  end

  describe '.to_easybill_document_items' do
    before do
      allow(Easybill::Position).to receive(:find_by) { position }
      allow(Easybill::Position).to receive(:find_by!) { position }
    end

    it 'maps the data' do
      mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

      expect(mapped_data).to eq(expected_mapping)
    end

    context 'when the position is not known' do
      let(:position) { nil }

      before do
        expected_mapping[0].delete(:position_id)

        allow(Easybill::Position).to receive(:find_by) { nil }
      end

      it 'maps the data without the position id' do
        mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

        expect(mapped_data).to eq(expected_mapping)
      end
    end

    context 'with date range booking attribute' do
      let(:description) { 'Resource name - What a cool resource sku<br/>26. November 2020 - 26. November 2020<br/>John Doe<br/>John Doe' }

      before do
         booking_resource_sku["booking_attribute_values"][0]["handle"] = "starts_on"
         booking_resource_sku["booking_attribute_values"][0]["value"] = Date.new(2020, 1, 1)
         booking_resource_sku["booking_attribute_values"][1]["handle"] = "ends_on"
         booking_resource_sku["booking_attribute_values"][1]["value"] = Date.new(2020, 1, 14)
      end

      it 'adds the date range as a description' do
        mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

        expect(mapped_data).to eq(expected_mapping)
      end
    end

    context 'with date and time range booking attribute' do
      let(:description) do
        "Resource name - What a cool resource sku<br/>10:00 - 11:00 (26. November 2020 - 26. November 2020)<br/>John Doe<br/>John Doe"
      end

      before do
         booking_resource_sku["booking_attribute_values"][0]["handle"] = "starts_on"
         booking_resource_sku["booking_attribute_values"][0]["value"] = Date.new(2020, 1, 1)
         booking_resource_sku["booking_attribute_values"][1]["handle"] = "ends_on"
         booking_resource_sku["booking_attribute_values"][1]["value"] = Date.new(2020, 1, 14)
         booking_resource_sku["booking_attribute_values"] << { "handle" => "start_time", "value" => "10:00" }
         booking_resource_sku["booking_attribute_values"] << { "handle" => "end_time", "value" => "11:00" }
      end

      it 'adds the date range as a description' do
        mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

        expect(mapped_data).to eq(expected_mapping)
      end
    end

    context 'with time range booking attribute' do
      let(:description) { 'Resource name - What a cool resource sku<br/>10:00 - 11:00<br/>John Doe<br/>John Doe' }

      before do
         booking_resource_sku["booking_attribute_values"] << { "handle" => "start_time", "value" => "10:00" }
         booking_resource_sku["booking_attribute_values"] << { "handle" => "end_time", "value" => "11:00" }
      end

      it 'adds the date range as a description' do
        mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

        expect(mapped_data).to eq(expected_mapping)
      end
    end

    context 'with product having a financial_account' do
      let(:financial_account) { double(:financial_account) }
      let(:expected_fin_account) { "financial_account" }

      before do
        booking_resource_sku["financial_account"] = nil

        allow(product_sku).to receive(:financial_account) { financial_account }
        allow(financial_account).to receive(:for_date) { 'financial_account' }
      end

      it 'adds the booking_account key to the document item' do
        mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

        expect(mapped_data).to eq(expected_mapping)
      end
    end

    context 'with product having a cost center' do
      let(:cost_center) { double(:cost_center) }
      let(:expected_cost_center) { "cost_center" }

      before do
        booking_resource_sku["cost_center"] = nil

        allow(product_sku).to receive(:cost_center) { cost_center }
        allow(cost_center).to receive(:value) { "cost_center" }
      end

      it 'adds the booking_account key to the document item' do
        mapped_data = described_class.new(booking: booking, booking_resource_sku: booking_resource_sku).call

        expect(mapped_data).to eq(expected_mapping)
      end
    end
  end
end
