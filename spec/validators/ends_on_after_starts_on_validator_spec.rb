require 'rails_helper'

RSpec.describe EndsOnAfterStartsOnValidator, type: :validator do
  before do
    I18n.locale = :en
  end

  after do
    I18n.locale = I18n.default_locale
  end

  let(:record) do
    double(
      :record,
      starts_on: starts_on,
      ends_on: ends_on
    )
  end

  let(:errors) do
    double(:errors)
  end

  let(:options) { {} }

  before do
    allow(record).to receive(:errors) { errors }
    allow(errors).to receive(:add)
  end

  describe '#validate' do
    subject(:validator) { described_class.new(options) }

    context 'when the start date is before the end date' do
      let(:starts_on) { 1.day.from_now }
      let(:ends_on) { starts_on + 1.day }

      it 'has no errors' do
        validator.validate(record)

        expect(record).not_to have_received(:errors)
      end
    end

    context 'when the start date is after the end date' do
      let(:starts_on) { 1.day.from_now }
      let(:ends_on) { starts_on - 1.day }

      it 'sets an error message' do
        validator.validate(record)

        expect(record).to have_received(:errors).once
        expect(errors).to have_received(:add).with(:ends_on, 'must not be before the start date')
      end
    end

    context 'when the start date equals the end date' do
      let(:starts_on) { 1.day.from_now }
      let(:ends_on) { starts_on }

      it 'sets an error message' do
        validator.validate(record)

        expect(record).to have_received(:errors).once
        expect(errors).to have_received(:add).with(:ends_on, 'must not be before the start date')
      end
    end

    context 'when one of the dates has an invalid format' do
      let(:starts_on) { 1.day.from_now }
      let(:ends_on) { '1234s5' }

      it 'sets an error message' do
        validator.validate(record)

        expect(record).to have_received(:errors).once
        expect(errors).to have_received(:add).with(:ends_on, 'has an invalid format')
      end
    end

    context 'when ends on is nil' do
      let(:starts_on) { 1.day.from_now }
      let(:ends_on) { nil }

      it 'it makes an early return' do
        validator.validate(record)

        expect(errors).not_to have_received(:add)
      end
    end

    context 'when starts_on is nil' do
      let(:starts_on) { nil }
      let(:ends_on) { 1.day.from_now }

      it 'it makes an early return' do
        validator.validate(record)

        expect(errors).not_to have_received(:add)
      end
    end

    context 'when same day is allowed' do
      let(:starts_on) { 1.day.from_now }
      let(:ends_on) { starts_on }
      let(:options) { { allow_same_day: true } }

      it 'it makes an early return' do
        validator.validate(record)

        expect(errors).not_to have_received(:add)
      end
    end
  end
end
