require 'rails_helper'

RSpec.describe BookingResourceSkus::Cancel, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku) { instance_double(BookingResourceSku) }

    subject { described_class.call(interactor_params) }

    let(:interactor_params) { cancellation_params.merge(booking_resource_sku: booking_resource_sku) }

    let(:cancellation_params) do
      {
        user_id: "user_id",
        cancellable_type: "cancellable_type",
        cancellable_id: "cancellable_id",
        cancellation_reason_id: "cancellation_reason_id"
      }
    end

    let(:cancellable) { double(:cancellable) }
    let(:save) { true }
    let(:cancellation_double) { double(:cancellation, save: save, errors: errors, cancellable: cancellable) }
    let(:errors) { double(:errors, full_messages: error_messages) }
    let(:error_messages) { [] }

    before do
      allow(Cancellation).to receive(:new).with(cancellation_params) { cancellation_double }
      allow(cancellable).to receive(:paper_trail_event=).with("cancel")
      allow(cancellable).to receive(:paper_trail) { double(:paper_trail, save_with_version: true) }
    end

    context "success" do
      context 'when no availability has been associated' do
        before do
          allow(booking_resource_sku).to receive(:booking_resource_sku_availability) { nil }
        end

        it { is_expected.to be_success }
      end

      context 'when an availability has been associated' do
        let(:booking_resource_sku_availability) { instance_double(BookingResourceSkuAvailability) }

        before do
          allow(booking_resource_sku).to receive(:booking_resource_sku_availability) { booking_resource_sku_availability }
          allow(BookingResourceSkuAvailabilities::CancelBookingResourceSkuAvailability).to receive(:call) { true }
        end

        it { is_expected.to be_success }

        it 'updates the context' do
          subject

          expect(subject.booking_resource_sku_availability).to eq(booking_resource_sku_availability)
        end

        it 'calls the CancelBookingResourceSkuAvailability interactor with the current context' do
          subject

          expect(BookingResourceSkuAvailabilities::CancelBookingResourceSkuAvailability).to have_received(:call).with(subject)
        end

        describe "creates cancellation" do
          it { is_expected.to be_success }
          it { expect(subject.cancellation).to eq(cancellation_double) }
        end
      end
    end

    context "failure" do
      let(:save) { false }
      let(:error_messages) { ["Failed"] }

      describe "should not create cancellation" do
        it { is_expected.to be_failure }

        it { expect(subject.message).to eq(error_messages) }
      end
    end
  end
end
