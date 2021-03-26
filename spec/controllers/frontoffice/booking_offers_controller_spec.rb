require 'rails_helper'

RSpec.describe Frontoffice::BookingOffersController, type: :controller do
  login_user

  describe '[GET] show' do
    let(:booking_offer) { instance_double("BookingOffer") }
    let(:load_booking_offer) { Frontoffice::LoadBookingOffer }
    let(:context) { double(:context, success?: true) }

    before do
      allow(load_booking_offer).to receive(:call) { context }
      allow(context).to receive(:booking_offer) { booking_offer }
    end

    it 'calls the interactor' do
      get :show, params: { booking_scrambled_id: 'booking_scrambled_id', scrambled_id: "scrambled_id" }

      expect(load_booking_offer).to have_received(:call).with(booking_scrambled_id: 'booking_scrambled_id', offer_scrambled_id: "scrambled_id")
    end

    context 'when it succeeds' do
      it 'sets @booking_offer and renders show' do
        get :show, params: { booking_scrambled_id: 'booking_scrambled_id', scrambled_id: "scrambled_id" }

        expect(assigns(:booking_offer)).to eq(booking_offer)
        expect(response).to render_template('booking_offers/show')
      end
    end

    context 'when it fails' do
      let(:context) { double(:context, success?: false, message: :not_found) }

      it 'renders error message' do
        get :show, params: { booking_scrambled_id: 'booking_scrambled_id', scrambled_id: "scrambled_id" }

        expect(context.message).to eq(:not_found)
      end
    end
  end
end
