require 'rails_helper'

RSpec.describe Frontoffice::BookingInvoicesController, type: :controller do
  login_user

  describe '[GET] show' do
    let(:booking_invoice) { instance_double(BookingInvoice) }
    let(:load_booking_invoice) { Frontoffice::LoadBookingInvoice }
    let(:context) { double(:context, success?: true) }

    before do
      allow(load_booking_invoice).to receive(:call) { context }
      allow(context).to receive(:booking_invoice) { booking_invoice }
    end

    it 'calls the interactor' do
      get :show, params: { booking_scrambled_id: 'booking_scrambled_id', scrambled_id: "scrambled_id" }

      expect(load_booking_invoice).to have_received(:call).with(booking_scrambled_id: 'booking_scrambled_id', invoice_scrambled_id: "scrambled_id")
    end

    context 'when it succeeds' do
      it 'sets @booking_invoice and renders show' do
        get :show, params: { booking_scrambled_id: 'booking_scrambled_id', scrambled_id: "scrambled_id" }

        expect(assigns(:booking_invoice)).to eq(booking_invoice)
        expect(response).to render_template('booking_invoices/show')
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
