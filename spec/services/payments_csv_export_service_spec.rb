require 'rails_helper'

RSpec.describe PaymentsCsvExportService, type: :service do
  subject(:service) { PaymentsCsvExportService.new(invoice) }

  let(:booking) { instance_double(Booking, starts_on: Time.zone.now) }
  let(:booking_resource_sku1) do
    {
      "id" => 1,
      "cost_center" => { "id" => 1, "value" => "10"},
      "financial_account" => { "id" => 1, "before_service_year" => "1111", "during_service_year" => "2222"},
      "price_cents" => 15000,
      "allow_partial_payment" => true
    }
  end
  let(:booking_resource_sku_group1) do
    {
      "id" => 1,
      "cost_center" => { "id" => 2, "value" => "20"},
      "financial_account" => { "id" => 1, "before_service_year" => "1111", "during_service_year" => "2222"},
      "price_cents" => 5000,
      "allow_partial_payment" => true
    }
  end
  let(:booking_resource_skus_snapshot) { [booking_resource_sku1] }
  let(:booking_resource_sku_groups_snapshot) { [booking_resource_sku_group1] }
  let(:payment) { instance_double(Payment, price_cents: 20000) }
  let(:payments) { [payment] }
  let(:invoice) {
    instance_double(
        BookingInvoice,
        booking: booking,
        payments: payments,
        booking_resource_skus_snapshot: booking_resource_skus_snapshot,
        booking_resource_sku_groups_snapshot: booking_resource_sku_groups_snapshot,
        created_at: Time.zone.now)
}

  describe '#accounting_data' do
    context 'when an invoice with one payment exists' do
      let(:expected_data) { [{"10"=>{"2222"=>150.0}, "20"=>{"2222"=>50.0}}, {}] }

      it 'assigns the right amount per payment due_on to the financial_account and the cost_center in one hash per due_on date' do
        accounting_data = service.accounting_data

        expect(accounting_data).to eq(expected_data)
      end
    end

    context 'when an invoice with a partial and a final payment exists' do
      let(:payment1) { instance_double(Payment, price_cents: 4000) }
      let(:payment2) { instance_double(Payment, price_cents: 16000) }
      let(:payments) { [payment1, payment2] }
      let(:expected_data) { [{"10"=>{"2222"=>30.0}, "20"=>{"2222"=>10.0}}, {"10"=>{"2222"=>120.0}, "20"=>{"2222"=>40.0}}] }

      it 'assigns the right amount per payment due_on to the financial_account and the cost_center in one hash per due_on date' do
        accounting_data = service.accounting_data

        expect(accounting_data).to eq(expected_data)
      end

      context 'when some booking_resource_skus are fully payed' do
        let(:booking_resource_sku2) do
          {
            "id" => 2,
            "cost_center" => { "id" => 1, "value" => "10"},
            "financial_account" => { "id" => 1, "before_service_year" => "1111", "during_service_year" => "2222"},
            "price_cents" => 10000,
            "allow_partial_payment" => false
          }
        end
        let(:booking_resource_skus_snapshot) { [booking_resource_sku1, booking_resource_sku2] }
        let(:payment1) { instance_double(Payment, price_cents: 14000) }
        let(:payment2) { instance_double(Payment, price_cents: 16000) }
        let(:payments) { [payment1, payment2] }
        let(:expected_data) { [{"10"=>{"2222"=>130.0}, "20"=>{"2222"=>10.0}}, {"10"=>{"2222"=>120.0}, "20"=>{"2222"=>40.0}}] }

        it 'assigns the amount per payment due_on to the financial_account and the cost_center in one hash per due_on date' do
          accounting_data = service.accounting_data

          expect(accounting_data).to eq(expected_data)
        end
      end
    end
  end

  describe '#update_hash' do
    let(:accounting1) { {} }
    let(:cost_center) { "10" }
    let(:financial_account) { "2222" }
    let(:amount) { 100.00 }
    let(:expected_data) { {"10" => {"2222" => 100.00} } }

    it 'updates the hash with the input data' do
      accounting_hash = service.update_hash(accounting1, cost_center, financial_account, amount)

      expect(accounting_hash).to eq(expected_data)
    end
  end
end
