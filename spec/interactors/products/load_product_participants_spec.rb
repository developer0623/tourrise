# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Products::LoadProductParticipants do
  subject { described_class.call(interactor_params) }

  let(:interactor_params) do
    { product_id: product_id, filter: filter, sort_by: sort_by }
  end

  let(:filter) { {} }
  let(:sort_by) { "customers.id" }

  context 'valid' do
    let(:product) { create(:product) }
    let(:product_sku) { create(:product_sku) }
    let(:filter) { { product_sku_id: product_sku_id } }

    let(:product_id) { product.id }
    let(:product_sku_id) { product_sku.id }

    describe 'loads participants' do
      let(:product_sku) { create(:product_sku, product: product) }
      let!(:booking) { create(:booking_with_participants, booking_attrs) }
      let(:participants_count) { 2 }
      let(:expected_participant) { booking.booking_participants.first }
      let(:booking_attrs) do
        {
          product_sku: product_sku,
          aasm_state: :booked,
          participants_count: participants_count
        }
      end

      context 'by product_sku_id' do
        it { is_expected.to be_success }
        it { expect(subject.booking_participants.size).to eq(participants_count) }

        it do
          participant_id = subject.booking_participants.first.id
          expect(participant_id).to eq(expected_participant.id)
        end
      end
    end
  end

  context 'invalid' do
    describe 'product not found' do
      let(:product_id) { 'test' }
      let(:error_message) { "Cannot find Product with id: #{product_id}" }

      it { is_expected.not_to be_success }
      it { expect(subject.message).to eq(error_message) }
    end
  end
end
