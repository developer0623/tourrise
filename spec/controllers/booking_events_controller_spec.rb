# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingEventsController, type: :controller do
  login_user

  describe '[GET] index' do
    let(:context) { double(:context, events: PaperTrail::Version.all) }
    let(:product) { FactoryBot.create(:product, :with_sku) }
    let(:booking) { FactoryBot.create(:booking, product_sku: product.product_skus.first) }
    let(:params) do
      { item_type: 'Booking', event: 'create', sort_by: 'created_at', sort_order: 'desc', booking_id: booking.id }
    end

    before do
      allow(Bookings::ListBookingEvents).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      get :index, params: params

      expect(Bookings::ListBookingEvents).to have_received(:call).with(
        booking: booking,
        page: nil,
        filter: {
          event: 'create',
          item_type: 'Booking'
        },
        sort: {
          by: 'created_at',
          order: 'desc'
        }
      )
    end

    it 'render list of events' do
      get :index, params: params

      expect(assigns(:events)).to eq(context.events)
      expect(response).to render_template('booking_events/index')
      expect(response).to have_http_status(:success)
    end
  end
end
