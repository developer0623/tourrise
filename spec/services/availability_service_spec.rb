require 'rails_helper'

RSpec.describe AvailabilityService do
  let(:availability) { instance_double(Availability) }
  let(:booking_resource_skus) { object_double(BookingResourceSku.all) }

  subject(:service) { described_class.new(availability) }

  describe '#available?' do
    before do
      allow(availability).to receive(:inventory_type) { inventory_type }
      allow(availability).to receive(:quantity) { availability_quantity }
    end

    context "when there is enough allocatable amount for the requested quantity" do
      let(:inventory_type) { :quantity }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 9 }
      let(:requested_quantity) { 1 }

      before do
        allow(availability).to receive(:allocated_quantity) { allocated_availability_quantity }
      end

      subject(:service) { described_class.new(availability).available?(requested_quantity, nil, nil) }

      it { is_expected.to be(true) }
    end

    context "when there is not enough allocatable amount for the requested quantity" do
      let(:inventory_type) { :quantity }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 10 }
      let(:requested_quantity) { 1 }

      before do
        allow(availability).to receive(:allocated_quantity) { allocated_availability_quantity }
      end

      subject(:service) { described_class.new(availability).available?(requested_quantity, nil, nil) }

      it { is_expected.to be(false) }
    end

    context "when there is enough allocatable amount for the requested quantity in a given date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 9 }
      let(:requested_quantity) { 1 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2020, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on }
        allow(availability).to receive(:ends_on) { requested_ends_on }
      end

      subject(:service) { described_class.new(availability).available?(requested_quantity, requested_starts_on, requested_ends_on) }

      it { is_expected.to be(true) }
    end

    context "when there is not enough allocatable amount for the requested quantity in a given date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 10 }
      let(:requested_quantity) { 1 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2020, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on }
        allow(availability).to receive(:ends_on) { requested_ends_on }
      end

      subject(:service) { described_class.new(availability).available?(requested_quantity, requested_starts_on, requested_ends_on) }

      it { is_expected.to be(false) }
    end
  end

  describe '#available_quantity' do
    before do
      allow(availability).to receive(:inventory_type) { inventory_type }
      allow(availability).to receive(:quantity) { availability_quantity }
    end

    context "when there is enough allocatable amount for the requested quantity" do
      let(:inventory_type) { :quantity }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 9 }

      before do
        allow(availability).to receive(:allocated_quantity) { allocated_availability_quantity }
      end

      subject(:service) { described_class.new(availability).available_quantity(nil, nil) }

      it { is_expected.to be(1) }
    end

    context "when there is not enough allocatable amount for the requested quantity" do
      let(:inventory_type) { :quantity }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 10 }

      before do
        allow(availability).to receive(:allocated_quantity) { allocated_availability_quantity }
      end

      subject(:service) { described_class.new(availability).available_quantity(nil, nil) }

      it { is_expected.to be(0) }
    end

    context "when there is enough allocatable amount for the requested quantity in a given date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 9 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2020, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on }
        allow(availability).to receive(:ends_on) { requested_ends_on }
      end

      subject(:service) { described_class.new(availability).available_quantity(requested_starts_on, requested_ends_on) }

      it { is_expected.to be(1) }
    end

    context "when there is not enough allocatable amount for the requested quantity in a given date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 10 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2020, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on }
        allow(availability).to receive(:ends_on) { requested_ends_on }
      end

      subject(:service) { described_class.new(availability).available_quantity(requested_starts_on, requested_ends_on) }

      it { is_expected.to be(0) }
    end

    context "when the requested date range is not matching the availability date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 0 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2020, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on + 1.day }
        allow(availability).to receive(:ends_on) { requested_ends_on - 1.day }
      end

      subject(:service) { described_class.new(availability).available_quantity(requested_starts_on, requested_ends_on) }

      it { is_expected.to be(-1) }
    end
  end

  describe "#score" do
    before do
      allow(availability).to receive(:inventory_type) { inventory_type }
      allow(availability).to receive(:quantity) { availability_quantity }
    end

    context "when there is enough allocatable amount for the requested quantity" do
      let(:inventory_type) { :quantity }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 9 }
      let(:requested_quantity) { 1 }

      before do
        allow(availability).to receive(:allocated_quantity) { allocated_availability_quantity }
      end

      it "adds 1000 to the allocatable quantity" do
        score = described_class.new(availability).score(requested_quantity, nil, nil)

        expect(score).to eq(1000)
      end
    end

    context "when there is not enough allocatable amount for the requested quantity" do
      let(:inventory_type) { :quantity }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 10 }
      let(:requested_quantity) { 1 }

      before do
        allow(availability).to receive(:allocated_quantity) { allocated_availability_quantity }
      end

      it "has an UNAVAILABLE score" do
        score = described_class.new(availability).score(requested_quantity, nil, nil)

        expect(score).to eq(-1)
      end
    end

    context "when there is not enough allocatable amount for the requested quantity in a given date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 10 }
      let(:requested_quantity) { 1 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2020, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on }
        allow(availability).to receive(:ends_on) { requested_ends_on }
      end

      it "has an UNAVAILABLE score" do
        score = described_class.new(availability).score(requested_quantity, requested_starts_on, requested_ends_on)

        expect(score).to eq(-1)
      end
    end

    context "when there is enough allocatable amount for the requested quantity in a given date range" do
      let(:inventory_type) { :quantity_in_date_range }
      let(:availability_quantity) { 10 }
      let(:allocated_availability_quantity) { 9 }
      let(:requested_quantity) { 1 }
      let(:requested_starts_on) { Date.new(2020, 1, 2) }
      let(:requested_ends_on) { Date.new(2030, 1, 15) }

      before do
        allow(availability).to receive(:allocated_quantity_in_date_range) { allocated_availability_quantity }
        allow(availability).to receive(:starts_on) { requested_starts_on }
        allow(availability).to receive(:ends_on) { requested_ends_on }
      end

      it "it returns 0 if the date range matches exactly" do
        score = described_class.new(availability).score(requested_quantity, requested_starts_on, requested_ends_on)

        expect(score).to eq(0)
      end

      it "it returns 1 if the date range is one day short" do
        score = described_class.new(availability).score(requested_quantity, requested_starts_on + 1.day, requested_ends_on)

        expect(score).to eq(1)
      end

      it "it returns 2 if the date range is two days short" do
        score = described_class.new(availability).score(requested_quantity, requested_starts_on + 1.day, requested_ends_on - 1.day)

        expect(score).to eq(2)
      end

      it "it has a max score of 999" do
        score = described_class.new(availability).score(requested_quantity, requested_starts_on + 1.day, requested_ends_on - 1000.days)

        expect(score).to eq(999)
      end
    end
  end
end
