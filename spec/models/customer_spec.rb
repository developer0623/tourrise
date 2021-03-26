# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer do
  context 'locale' do
    it 'can be empty' do
      customer = build(:customer)

      customer.locale = nil

      expect(customer).to be_valid
    end

    it 'has to be an alpha2 code' do
      customer = build(:customer)
      alpha2 = 'de'

      customer.locale = alpha2
      expect(customer).to be_valid
    end

    it 'fails with alpha3' do
      customer = build(:customer)
      alpha3 = 'deu'

      customer.locale = alpha3

      expect(customer).not_to be_valid
    end

    it 'fails with any other name' do
      customer = build(:customer)
      locale_name = 'German'

      customer.locale = locale_name

      expect(customer).not_to be_valid
    end
  end
end
