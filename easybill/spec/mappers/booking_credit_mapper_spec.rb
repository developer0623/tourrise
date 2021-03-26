# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::BookingCreditMapper do
  let(:booking) { double(Booking, starts_on: "starts_on")}
  let(:description) { "Deposit - #{I18n.l(Date.new(2020, 10, 10).to_date)}" }
  let(:financial_account) { double(FinancialAccount, for_date: "3333") }
  let(:cost_center) { double(CostCenter, value: "10") }
  let(:expected_fin_account) { "3333" }
  let(:expected_cost_center) { "10" }
  let(:booking_credit) do
    {
      "name" => "Deposit",
      "price_cents" => 10000,
      "financial_account_id" => 1,
      "cost_center_id" => 1,
      "created_at" => Date.new(2020, 10, 10)
    }
  end
  let(:expected_mapping) do
    [
      {
        number: "-",
        description: description,
        quantity: 1,
        vat_percent: 0.0,
        export_cost_1: expected_cost_center,
        booking_account: expected_fin_account,
        single_price_net: -10000.0
      }
    ]
  end

  before do
    allow(FinancialAccount).to receive(:find) { financial_account }
    allow(CostCenter).to receive(:find) { cost_center }
  end

  describe '.to_easybill_document_items' do
    it 'maps the data' do
      mapped_data = described_class.new(booking: booking, booking_credit: booking_credit).call

      expect(mapped_data).to eq(expected_mapping)
    end

    it 'finds the financial_account and cost_center' do
      described_class.new(booking: booking, booking_credit: booking_credit).call

      expect(FinancialAccount).to have_received(:find).with(1)
      expect(financial_account).to have_received(:for_date).with(starts_on: "starts_on")
      expect(CostCenter).to have_received(:find).with(1)
    end
  end
end
