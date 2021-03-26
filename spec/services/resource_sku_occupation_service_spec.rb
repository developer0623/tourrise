require 'rails_helper'

RSpec.describe ResourceSkuOccupationService, type: :service do
  let(:resource_sku) { instance_double(ResourceSku) }
  let(:occupation_configuration) { instance_double(OccupationConfiguration) }

  let(:adults_count) { 1 }
  let(:kids_count) { 2 }

  let(:occupiable_by_people) { true }
  let(:occupiable_by_adults) { true }
  let(:occupiable_by_kids) { true }
  let(:occupiable_by_babies) { true }

  before do
    allow(resource_sku).to receive(:occupation_configuration) { occupation_configuration }
    allow(occupation_configuration).to receive(:occupiable_with_count?) { occupiable_by_people }
    allow(occupation_configuration).to receive(:occupiable_by_adults_count?) { occupiable_by_adults }
    allow(occupation_configuration).to receive(:occupiable_by_kids_count?) { occupiable_by_kids }
    allow(occupation_configuration).to receive(:occupiable_by_babies_count?) { occupiable_by_babies }
  end

  describe '#matches_occupation_configuration?' do
    subject(:occupiable) do
      described_class.new(resource_sku).matches_occupation_configuration?(adults: adults_count, kids: kids_count)
    end

    context 'when no configuration is present' do
      before do
        allow(occupation_configuration).to receive(:present?) { false }
      end

      it { is_expected.to be(true) }
    end

    context 'when all parameters are within the configured boundaries' do
      it 'calls the configuration with the people count' do
        subject

        expect(occupation_configuration).to have_received(:occupiable_with_count?).with(3)
      end

      it 'calls the configuration with the adults count' do
        subject

        expect(occupation_configuration).to have_received(:occupiable_by_adults_count?).with(1)
      end

      it 'calls the configuration with the kids count' do
        subject

        expect(occupation_configuration).to have_received(:occupiable_by_kids_count?).with(2)
      end

      it { is_expected.to be(true) }
    end

    context 'when the sku is not occupiable by the requested people count' do
      let(:occupiable_by_people) { false }

      it { is_expected.to be(false) }
    end

    context 'when the sku is not occupiable by the requested adults count' do
      let(:occupiable_by_adults) { false }

      it { is_expected.to be(false) }
    end

    context 'when the sku is not occupiable by the requested kids count' do
      let(:occupiable_by_kids) { false }

      it { is_expected.to be(false) }
    end
  end
end
