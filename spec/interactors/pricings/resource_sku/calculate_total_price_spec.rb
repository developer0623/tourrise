require 'rails_helper'

RSpec.describe Pricings::ResourceSku::CalculateTotalPrice, type: :interactor do
  let(:organizer) { described_class }

  subject { organizer.call(service_params) }

  let(:booking) { create(:booking) }

  let(:booking_room_assignment) { create(:booking_room_assignment, booking: booking, adults: 2) }

  let(:resource_sku) do
    create(:resource_sku_with_pricings,
      pricings_count: 1,
      pricings_traits: pricings_traits,
      pricings_options: { starts_on: booking.starts_on, ends_on: booking.ends_on, price: price }
    )
  end

  let(:service_params) do
    {
      resource_sku: resource_sku,
      starts_on: booking.starts_on,
      ends_on: booking.ends_on,
      adults: booking_room_assignment.adults,
      kids: booking_room_assignment.kids,
      babies: booking_room_assignment.babies
    }
  end

  let(:pricings_traits) { [:fixed] }
  let(:price) { 10 }

  context 'valid' do
    context 'FixedStrategy' do
      describe 'should calculate price' do
        it { is_expected.to be_success }
        it { expect(subject.price.to_f).to eq(10.0) }
      end
    end

    context 'PerPersonStrategy' do
      describe 'should calculate price' do
        let(:pricings_traits) { [:per_person] }

        it { is_expected.to be_success }
        it { expect(subject.price.to_f).to eq(20.0) }
      end
    end

    context 'PerPersonAndNightStrategy' do
      describe 'should calculate price' do
        let(:booking) { create(:booking, starts_on: Time.zone.now, ends_on: 2.days.from_now) }
        let(:pricings_traits) { [:per_person_and_night] }
        let(:price) { 5 }

        it { is_expected.to be_success }
        it { expect(subject.price.to_f).to eq(20.0) }
      end
    end

    context 'ConsecuiveDays' do
      describe 'should calculate price' do
        let(:booking) { create(:booking, starts_on: Time.zone.now, ends_on: 2.days.from_now) }
        let(:pricing) { resource_sku.resource_sku_pricings.first }
        let(:pricings_traits) { [:consecutive_days] }
        let!(:consecutive_days_range) do
          create(:consecutive_days_range, resource_sku_pricing: pricing, from: 1, to: 3, price: 10)
        end

        it { is_expected.to be_success }
        it { expect(subject.price.to_f).to eq(10.0) }
      end
    end
  end

  context 'invalid' do
    context 'resource_sku nil' do
      let(:service_params) { super().merge(resource_sku: nil) }

      it { is_expected.not_to be_success }
      it { expect(subject.errors).to include(':resource_sku Can only be type of ActiveRecord!') }
    end
  end
end
