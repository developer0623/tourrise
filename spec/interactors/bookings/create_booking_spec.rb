# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::CreateBooking do
  let(:current_user) { instance_double(User, id: 'user_id') }
  let(:customer) { instance_double(Customer, id: 'customer_id') }
  let(:product_sku) { instance_double(ProductSku, id: 'product_sku_id', name: 'Product Sku name') }
  let(:product) { instance_double(Product, id: 'product_id', name: 'Product name') }
  let(:booking) { instance_double(Booking, adults: 1, kids: 0, babies: 0) }
  let(:booking_participants) { object_double(Customer.all) }
  let(:participant) { instance_double(Customer) }

  let(:booking_params) do
    {
      first_name: 'Peter',
      last_name: 'Polzer',
      email: 'peter@polzer.de',
      customer_id: customer.id,
      product_sku_id: product_sku.id
    }
  end

  let(:call_params) do
    {
      current_user: current_user,
      params: booking_params
    }
  end

  let(:participants_double) { double(:participants) }

  context 'manual booking creation via backoffice' do
    before do
      allow(Booking).to receive(:new) { booking } 
      allow(booking).to receive(:participants) { participants_double }
      allow(participants_double).to receive(:new)
      allow(booking).to receive(:save) { true }
      allow(booking).to receive(:participants) { booking_participants }
      allow(booking).to receive(:request)
      allow(booking).to receive(:title=) { true }
      allow(booking).to receive(:product_sku) { product_sku }
      allow(BookingTitle).to receive(:from_product_sku) { "Product name Product Sku name"}
      allow(booking_participants).to receive(:adults) { booking_participants }
      allow(booking_participants).to receive(:new) { participant }
    end

    describe '#call' do
      subject(:context) { described_class.call(call_params) }

      it 'assigns the create params' do
        described_class.call(call_params)

        expected_params = {
          first_name: 'Peter',
          last_name: 'Polzer',
          email: 'peter@polzer.de',
          customer_id: 'customer_id',
          product_sku_id: 'product_sku_id',
          creator_id: 'user_id'
        }

        expect(Booking).to have_received(:new).with(expected_params)
      end

      it 'generates the booking title' do
        described_class.call(call_params)

        expect(BookingTitle).to have_received(:from_product_sku).with(product_sku)
        expect(booking).to have_received(:title=).with("Product name Product Sku name")
      end

      it 'generates the participant placeholders' do
        described_class.call(call_params)

        expect(booking_participants).to have_received(:new).with(placeholder: true)
      end

      it { is_expected.to be_success }
    end
  end
end
