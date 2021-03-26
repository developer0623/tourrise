require 'rails_helper'

RSpec.describe Documents::Initialize::BookingInvoice, type: :interactor do
  describe '.call' do
    subject { described_class.call(**interactor_attributes) }

    let(:interactor_attributes) { { booking_id: booking_id, params: params } }

    let(:params) do
      {
        "payments_attributes" => payments_attributes,
        "description" => description
      }
    end

    let(:booking) { create(:booking, customer: customer, product_sku: product_sku) }
    let(:booking_id) { booking.id }
    let(:customer) { create(:customer) }
    let(:product_sku) { create(:product_sku) }
    let(:description) { "description" }
    let(:now) { Time.zone.now }

    let(:payments_attributes) do
      {
        "0" => { "price" => 100, "due_on" => now },
        "1" => { "price" => 100, "due_on" => now }
      }
    end

    describe "success" do
      describe "initializes attributes correctly" do
        let(:expected_document_attributes) do
          {
            booking_id: booking.id,
            booking_snapshot: hash_including(booking.attributes.as_json),
            customer_snapshot: hash_including(customer.attributes.as_json),
            product_sku_snapshot: hash_including(product_sku.attributes.as_json),
            description: description
          }
        end

        it { is_expected.to be_success }

        it { expect(subject.document).to have_attributes(expected_document_attributes) }

        it do
          expect(subject.document.payments).to match_array([
            have_attributes(class: Payment, price_cents: 10000, due_on: now.to_date),
            have_attributes(class: Payment, price_cents: 10000, due_on: now.to_date)
          ])
        end

        describe "with booking_resource_skus" do
          let!(:booking_resource_sku1) { create(:booking_resource_sku, booking: booking) }
          let!(:booking_resource_sku2) { create(:booking_resource_sku, booking: booking) }

          let(:expected_document_attributes) do
            {
              booking_resource_skus_snapshot: match_array([
                hash_including(booking_resource_sku1.serialize_for_snapshot.as_json),
                hash_including(booking_resource_sku2.serialize_for_snapshot.as_json)
              ])
            }
          end

          it { is_expected.to be_success }
          it { expect(subject.document).to have_attributes(expected_document_attributes) }
        end

        describe "with booking_resource_sku_groups" do
          let!(:booking_resource_sku_group1) { create(:booking_resource_sku_group, booking: booking) }
          let!(:booking_resource_sku_group2) { create(:booking_resource_sku_group, booking: booking) }

          let(:expected_document_attributes) do
            {
              booking_resource_sku_groups_snapshot: match_array([
                hash_including(booking_resource_sku_group1.serialize_for_snapshot.as_json),
                hash_including(booking_resource_sku_group2.serialize_for_snapshot.as_json)
              ])
            }
          end

          it { is_expected.to be_success }
          it { expect(subject.document).to have_attributes(expected_document_attributes) }
        end

        describe "with booking_resource_sku_groups" do
          let!(:booking_credit1) { create(:booking_credit, booking: booking) }
          let!(:booking_credit2) { create(:booking_credit, booking: booking) }

          let(:expected_document_attributes) do
            {
              booking_credits_snapshot: match_array([
                hash_including(booking_credit1.serialize_for_snapshot.as_json),
                hash_including(booking_credit2.serialize_for_snapshot.as_json)
              ])
            }
          end

          it { is_expected.to be_success }
          it { expect(subject.document).to have_attributes(expected_document_attributes) }
        end
      end

      describe "marks payments for distruction" do
        let(:payments_attributes) do
          {
            "0" => { "price" => 100, "due_on" => now },
            "1" => { "price" => 0, "due_on" => now }
          }
        end

        it { is_expected.to be_success }

        it "only one payment" do
          document = subject.document

          document.save

          expect(document.payments.count).to eq(1)
        end
      end

      describe "adds document references" do
        describe "for booking_resource_sku" do
          let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }

          it { is_expected.to be_success }
          it { expect { subject.document.save }.to change { DocumentReference.count }.by(1) }
        end

        describe "for booking_resource_sku_group" do
          let!(:booking_resource_sku_group) { create(:booking_resource_sku_group, booking: booking) }

          it { is_expected.to be_success }
          it { expect { subject.document.save }.to change { DocumentReference.count }.by(1) }
        end

        describe "for booking_credit" do
          let!(:booking_credit) { create(:booking_credit, booking: booking) }

          it { is_expected.to be_success }
          it { expect { subject.document.save }.to change { DocumentReference.count }.by(1) }
        end
      end
    end

    describe "failure" do
      describe "booking_id is nil" do
        let(:expected_message) { I18n.t("interactor_errors.empty", attribute: :booking_id) }
        let(:booking_id) { nil }

        it { is_expected.to be_failure }
        it { expect(subject.message).to eq(expected_message) }
      end

      describe "booking doesn't exist" do
        let(:expected_message) { I18n.t("errors.not_found") }
        let(:booking_id) { 100500 }

        it { is_expected.to be_failure }
        it { expect(subject.message).to eq(expected_message) }
      end
    end
  end
end
