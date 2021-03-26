# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingOffersController, type: :controller do
  login_user

  describe '[POST] create' do
    let(:booking_id) { 'a_booking_id' }
    let(:context) { double(:context, success?: true, message: nil) }

    before do
      allow(Documents::Create::BookingOffer).to receive(:call) { context }
    end

    it 'calls the interactor' do
      post :create, params: { booking_id: booking_id }

      expect(Documents::Create::BookingOffer).to have_received(:call).with(booking_id: 'a_booking_id')
    end

    context 'when it succeeds' do
      it 'redirects the user to the booking url' do
        create_request = post :create, params: { booking_id: booking_id }

        expect(create_request).to redirect_to(booking_path(id: 'a_booking_id'))
      end

      it 'sets a success info message' do
        post :create, params: { booking_id: booking_id }

        expect(flash[:notice]).to include("Das Angebot wurde erfolgreich erstellt und kann in Kürze abgerufen werden")
      end
    end

    context 'when it fails' do
      let(:context) { double(:context, success?: false, message: 'an_error_message') }

      it 'redirects the user to the booking url' do
        create_request = post :create, params: { booking_id: booking_id }

        expect(create_request).to redirect_to(booking_path(id: 'a_booking_id'))
      end

      it 'sets an alert info message' do
        post :create, params: { booking_id: booking_id }

        expect(flash[:error]).to eq('an_error_message')
      end
    end
  end
end
