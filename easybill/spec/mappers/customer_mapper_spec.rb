# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CustomerMapper do
  let(:customer_id) { 1234 }
  let(:birthdate) { Date.new(1987, 9, 14) }
  let(:created_at) { DateTime.new(2018, 12, 12, 10, 0o0, 0o0) }
  let(:gender) { nil }
  let(:country) { 'DE' }
  let(:company_name) { nil }
  let(:customer) do
    instance_double(Customer,
                    id: 1,
                    title: 'a_title',
                    company_name: company_name,
                    first_name: 'a_first_name',
                    last_name: 'a_last_name',
                    gender: gender,
                    birthdate: birthdate,
                    email: 'foo@bar.de',
                    primary_phone: '1111',
                    secondary_phone: nil,
                    address_line_1: 'hottentotten 123',
                    zip: '22234',
                    city: 'goodtown',
                    locale: 'de',
                    country: country,
                    created_at: created_at)
  end

  describe '.to_easybill_customer' do
    let(:mapped_data) { described_class.to_easybill_customer(customer) }

    it 'maps the title' do
      expect(mapped_data[:title]).to eq('a_title')
    end

    it 'maps the first_name' do
      expect(mapped_data[:first_name]).to eq('a_first_name')
    end

    it 'maps the last_name' do
      expect(mapped_data[:last_name]).to eq('a_last_name')
    end

    it 'maps the gender' do
      expect(mapped_data[:salutation]).to eq(0)
    end

    it 'maps the birthdate' do
      expect(mapped_data[:birth_date]).to eq(birthdate)
    end

    it 'maps the email' do
      expect(mapped_data[:emails]).to contain_exactly('foo@bar.de')
    end

    it 'maps the primary_phone' do
      expect(mapped_data[:phone_1]).to eq('1111')
    end

    it 'maps the secondary_phone' do
      expect(mapped_data[:phone_2]).to eq(nil)
    end

    it 'maps the address_line_1' do
      expect(mapped_data[:street]).to eq('hottentotten 123')
    end

    it 'maps the zip' do
      expect(mapped_data[:zip_code]).to eq('22234')
    end

    it 'maps the city' do
      expect(mapped_data[:city]).to eq('goodtown')
    end

    it 'maps the created_at' do
      expect(mapped_data[:since_date]).to eq(created_at)
    end

    it 'maps the country' do
      expect(mapped_data[:country]).to eq('DE')
    end

    it 'maps additional info' do
      expect(mapped_data[:info_2]).to eq('Backoffice ID: 1')
    end

    context 'with female gender' do
      let(:gender) { 'female' }

      it 'maps the gender' do
        expect(mapped_data[:salutation]).to eq(2)
      end
    end

    context 'with a company_name' do
      let(:company_name) { 'test Co.'}

      it 'maps the gender' do
        expect(mapped_data[:company_name]).to eq('test Co.')
      end
    end

    context 'with male gender' do
      let(:gender) { 'male' }

      it 'maps the gender' do
        expect(mapped_data[:salutation]).to eq(1)
      end
    end

    context 'with country EN' do
      let(:country) { 'EN' }

      it 'maps the country' do
        expect(mapped_data[:country]).to eq('UK')
      end
    end

    context 'with country GB' do
      let(:country) { 'GB' }

      it 'maps the country' do
        expect(mapped_data[:country]).to eq('UK')
      end
    end

    context 'without a country' do
      let(:country) { nil }

      it 'does not map the country' do
        expect(mapped_data[:country]).not_to be
      end
    end
  end
end
