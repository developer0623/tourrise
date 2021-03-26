require 'rails_helper'

RSpec.describe BookingResourceSkuValidator, type: :validator do
  describe '#valid?' do
    let(:booking_resource_sku) { instance_double(BookingResourceSku) }
    let(:participants) { object_double(Customer.all) }
    let(:availability) { instance_double(Availability) }

    let(:subject) { described_class.new(booking_resource_sku).valid? }

    context 'without an occupation configuration' do
      let(:resource_sku_snapshot) { {} }

      before do
        allow(booking_resource_sku).to receive(:availability) { availability }
        allow(booking_resource_sku).to receive(:resource_sku_snapshot) { resource_sku_snapshot }
        allow(booking_resource_sku).to receive(:participants) { participants }
      end

      context 'when there is more than one participant associated' do
        before do
          allow(participants).to receive(:count) { 2 }
        end

        it { is_expected.to be(true) }
      end

      context 'when there is less then one participant associated' do
        before do
          allow(participants).to receive(:count) { 0 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there is exactly one participant associated' do
        before do
          allow(participants).to receive(:count) { 1 }
        end

        it { is_expected.to be(true) }
      end

      context 'when there is less then one participant associated and no availability assigned' do
        let(:availability) { nil }

        before do
          allow(participants).to receive(:count) { 0 }
        end

        it { is_expected.to be(true) }
      end
    end

    context 'with an occupation configuration' do
      let(:resource_sku_snapshot) do
        {
          'occupation_configuration' => {
            'max_occupancy' => 3,
            'min_occupancy' => 3,
            'max_adults' => 3,
            'min_adults' => 1,
            'max_kids' => 2,
            'min_kids' => 0,
            'max_babies' => 2,
            'min_babies' => 0,
          }
        }
      end

      let(:participants) { object_double(Customer.all, count: 3) }
      let(:adult_participants) { object_double(Customer.all, count: 3) }
      let(:kid_participants) { object_double(Customer.all, count: 0) }
      let(:baby_participants) { object_double(Customer.all, count: 0) }

      before do
        allow(booking_resource_sku).to receive(:resource_sku_snapshot) { resource_sku_snapshot }
        allow(booking_resource_sku).to receive(:participants) { participants }
        allow(booking_resource_sku).to receive(:availability) { availability }
        allow(participants).to receive(:adults) { adult_participants }
        allow(participants).to receive(:kids) { kid_participants }
        allow(participants).to receive(:babies) { baby_participants }
      end

      context 'when there are more participants than the max occupancy allows associated' do
        before do
          allow(participants).to receive(:count) { 4 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are less than required participants associated' do
        before do
          allow(participants).to receive(:count) { 2 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are exactly the required participants associated' do
        before do
          allow(participants).to receive(:count) { 3 }
        end

        it { is_expected.to be(true) }
      end

      context 'when there are more adults than the max adults allows associated' do
        before do
          allow(adult_participants).to receive(:count) { 4 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are less adults than required associated' do
        before do
          allow(adult_participants).to receive(:count) { 0 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are exactly the required adults associated' do
        before do
          allow(adult_participants).to receive(:count) { 3 }
        end

        it { is_expected.to be(true) }
      end

      context 'when there are more kids than the max kids allows associated' do
        before do
          allow(kid_participants).to receive(:count) { 4 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are less kids than required associated' do
        before do
          allow(kid_participants).to receive(:count) { -1 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are enough kids assoicated' do
        before do
          allow(kid_participants).to receive(:count) { 0 }
        end

        it { is_expected.to be(true) }
      end

      context 'when there are more babys than the max babys allows associated' do
        before do
          allow(baby_participants).to receive(:count) { 4 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are less babys than required associated' do
        before do
          allow(baby_participants).to receive(:count) { -1 }
        end

        it { is_expected.to be(false) }
      end

      context 'when there are enough babys assoicated' do
        before do
          allow(baby_participants).to receive(:count) { 0 }
        end

        it { is_expected.to be(true) }
      end
    end
  end
end