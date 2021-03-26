require 'rails_helper'

RSpec.describe ResourceSkuAvailabilityService do
  let(:resource_sku) { instance_double(ResourceSku) }
  let(:availability_service) { instance_double(AvailabilityService, score: 1) }

  subject(:service) { described_class.new(resource_sku) }

  describe "#needs_availability?" do
    let(:inventories) { [] }

    subject(:available) { service.needs_availability? }

    before do
      allow(resource_sku).to receive(:inventories) { inventories }
    end

    context 'when no inventories are defined' do
      let(:inventories) { [] }

      it { is_expected.to be(false) }
    end

    context 'when no availabilties are defined' do
      let(:inventories) { [inventory]}
      let(:inventory) { instance_double(Inventory, availabilities: []) }

      it { is_expected.to be(false) }
    end

    context 'when at least one availability is defined' do
      let(:inventories) { [inventory]}
      let(:inventory) { instance_double(Inventory, availabilities: ['there_is_one']) }

      it { is_expected.to be(true) }
    end
  end

  describe '#available_for_booking?' do
    let(:booking) { instance_double(Booking, starts_on: 'starts_on', ends_on: 'ends_on') }
    let(:inventories) { [] }
    let(:availabilities) { [] }

    before do
      allow(resource_sku).to receive(:inventories) { inventories }
    end

    context 'when no inventories are defined' do
      before do
        allow(inventories).to receive(:blank?) { true }
      end

      subject(:available) { service.available_for_booking?(booking) }

      it { is_expected.to be(true) }
    end

    context 'with inventory_type quantity' do
      let(:inventories) { [inventory] }
      let(:inventory) { instance_double(Inventory) }
      let(:availabilities) { [availability] }
      let(:availability) { instance_double(Availability) }

      subject(:available) { service.available_for_booking?(booking) }

      before do
        allow(inventory).to receive(:availabilities) { availabilities }
        allow(AvailabilityService).to receive(:new) { availability_service }
        allow(availability_service).to receive(:available?) { true }
      end

      it 'initializes an availability service' do
        subject

        expect(AvailabilityService).to have_received(:new).with(availability)
      end

      it 'checks if the requested quantity is available on the availability through the availability_service' do
        subject

        expect(availability_service).to have_received(:available?).with(1, 'starts_on', 'ends_on')
      end
    end

    context 'with quantity in date range availability type' do
      let(:inventories) { [inventory] }
      let(:inventory) { instance_double(Inventory) }
      let(:availabilities) { [availability] }
      let(:availability) { instance_double(Availability) }

      before do
        allow(inventory).to receive(:availabilities) { availabilities }

        allow(AvailabilityService).to receive(:new) { availability_service }
        allow(availability_service).to receive(:available?) { true }
      end

      subject { service.available_for_booking?(booking) }

      it 'initializes an availability service' do
        subject

        expect(AvailabilityService).to have_received(:new).with(availability)
      end

      it 'checks if the requested quantity is available on the availability through the availability_service' do
        subject

        expect(availability_service).to have_received(:available?).with(1, 'starts_on', 'ends_on')
      end
    end
  end

  describe '#find_bookable_availability_by_score' do
    let(:booking) { instance_double(Booking, starts_on: 'starts_on', ends_on: 'ends_on') }
    let(:inventories) { [inventory] }
    let(:inventory) { instance_double(Inventory, inventory_type: :quantity, quantity_type?: true, availabilities: availabilities ) }
    let(:availabilities) { [] }

    before do
      allow(resource_sku).to receive(:inventories) { inventories }
    end

    context 'with one bookable availability' do
      let(:availabilities) { [availability] }
      let(:availability) { instance_double(Availability) }

      before do
        allow(AvailabilityService).to receive(:new) { availability_service }
        allow(availability_service).to receive(:available?) { true }
      end

      it 'returns the availability' do
        result = service.find_bookable_availability_by_score(1, 'starts_on', 'ends_on')

        expect(result).to eq(availability)
      end
    end

    context 'with no bookable availability' do
      before do
        allow(AvailabilityService).to receive(:new) { availability_service }
        allow(availability_service).to receive(:available?) { false }
        allow(availability_service).to receive(:score) { 1 }
      end

      it 'returns nil' do
        result = service.find_bookable_availability_by_score(1, 'starts_on', 'ends_on')

        expect(result).to be(nil)
      end
    end

    context 'with two availabilities (first one is not bookable, second one is bookable)' do
      let(:availabilities) { [full_availability, bookable_availability] }
      let(:full_availability) { instance_double(Availability) }
      let(:bookable_availability) { instance_double(Availability) }

      let(:full_availability_service) { instance_double(AvailabilityService) }
      let(:bookable_availability_service) { instance_double(AvailabilityService) }

      before do
        allow(AvailabilityService).to receive(:new).with(full_availability) { full_availability_service }
        allow(full_availability_service).to receive(:available?) { false }

        allow(AvailabilityService).to receive(:new).with(bookable_availability) { bookable_availability_service }
        allow(bookable_availability_service).to receive(:available?) { true }
        allow(bookable_availability_service).to receive(:score) { 1 }
      end

      it 'returns the bookable (second) availability' do
        result = service.find_bookable_availability_by_score(1, 'starts_on', 'ends_on')

        expect(result).to be(bookable_availability)
      end
    end

    context 'with two availabilities are bookable' do
      let(:availabilities) { [first_bookable_availability, second_bookable_availability] }
      let(:first_bookable_availability) { instance_double(Availability) }
      let(:second_bookable_availability) { instance_double(Availability) }

      let(:first_bookable_availability_service) { instance_double(AvailabilityService) }
      let(:second_bookable_availability_service) { instance_double(AvailabilityService) }

      before do
        allow(AvailabilityService).to receive(:new).with(first_bookable_availability) { first_bookable_availability_service }
        allow(first_bookable_availability_service).to receive(:available?) { true }
        allow(first_bookable_availability_service).to receive(:score) { 2 }

        allow(AvailabilityService).to receive(:new).with(second_bookable_availability) { second_bookable_availability_service }
        allow(second_bookable_availability_service).to receive(:available?) { true }
        allow(second_bookable_availability_service).to receive(:score) { 1 }
      end

      it 'returns the availability with the lowest score' do
        result = service.find_bookable_availability_by_score(1, 'starts_on', 'ends_on')

        expect(result).to be(second_bookable_availability)
      end
    end
  end
end
