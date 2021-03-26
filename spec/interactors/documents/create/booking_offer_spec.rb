# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Documents::Create::BookingOffer, type: :interactor do
  subject { described_class.call(booking_id: booking.id) }

  let(:customer) { create(:customer) }
  let(:user) { create(:user) }
  let(:booking) { create(:booking, assignee: user, aasm_state: :in_progress, customer: customer) }
  let(:booking_service) { instance_double(BookingService) }

  before do
    ActiveJob::Base.queue_adapter = :test
    allow(BookingService).to receive(:new) { booking_service }
    allow(booking_service).to receive(:offer_creatable?) { true }
  end

  describe '.call' do
    it 'creates a booking offer' do
      expect { subject }.to change { BookingOffer.count }.by(1)
    end

    it { is_expected.to be_success }

    it 'publishes the message' do
      expect { subject }.to have_enqueued_job(PublishEventJob).with { |event_name, payload|
        expect(event_name).to eq('booking_offers.created')
        expect(payload).to eq({ "id" => booking.reload.booking_offers.last.id, "booking_id" => booking.id })
      }
    end

    it 'changes the secondary state of the booking' do
      expect { subject }.to change { booking.reload.secondary_state }.from(nil).to("offer_sent")
    end

    context 'with a booking resource sku' do
      let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }

      it 'creates a booking document reference' do
        expect { subject }.to change { booking_resource_sku.reload.offers.count }.by(1)
      end

      it 'stores the snapshot' do
        expected_booking_resource_sku = booking_resource_sku.serialize_for_snapshot.as_json

        expect(subject.document.booking_resource_skus_snapshot).to contain_exactly(expected_booking_resource_sku)
      end
    end

    context 'with a booking resource sku group' do
      let!(:booking_resource_sku_group) { create(:booking_resource_sku_group_with_booking_resource_skus, booking: booking) }

      it 'creates a booking document reference' do
        expect { subject }.to change { booking_resource_sku_group.reload.offers.count }.by(1)
      end

      it 'stores the snapshot' do
        expected_booking_resource_sku_group = booking_resource_sku_group.serialize_for_snapshot.as_json

        expect(subject.document.booking_resource_sku_groups_snapshot).to contain_exactly(expected_booking_resource_sku_group)
      end
    end

    context 'with a booking credit' do
      let!(:booking_credit) { create(:booking_credit, booking: booking) }

      it 'creates a booking document reference' do
        expect { subject }.to change { booking_credit.reload.offers.count }.by(1)
      end

      it 'stores the snapshot' do
        expect(subject.document.booking_credits_snapshot).to contain_exactly(booking_credit.serialize_for_snapshot.as_json)
      end
    end
  end
end
