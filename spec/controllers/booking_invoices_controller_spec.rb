# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingInvoicesController, type: :controller do
  login_user

  describe '[POST] create' do
    let(:booking_id) { 'a_booking_id' }
    let(:context) { double(:context, success?: true, message: nil) }
    let(:create_params) do
      {
        "booking_resource_sku_ids" => ["1","2"],
        "payments_attributes" => { "0" => { "price"=>"10", "due_on"=>"2020-10-10" } }
      }
    end
    let(:params) do
      {
        "booking_id" => booking_id,
        "booking_invoice" => {
          "booking_resource_sku_ids" => [1,2],
          "payments_attributes" => { "0" => { "price"=>"10", "due_on"=>"2020-10-10" }
          }
        }
      }
    end

    before do
      allow(Documents::Create::BookingInvoice).to receive(:call) { context }
    end

    it 'calls the interactor' do
      post :create, params: params

      expect(Documents::Create::BookingInvoice).to have_received(:call).with(booking_id: 'a_booking_id', params: create_params)
    end

    context 'when it succeeds' do
      let(:context) { double(:context, success?: true, message: nil) }

      it 'redirects the user to the booking url' do
        create_request = post :create, params: params

        expect(create_request).to redirect_to(booking_path(id: 'a_booking_id'))
      end

      it 'sets a success info message' do
        post :create, params: params

        expect(flash[:notice]).to include("Die Rechnung wurde erfolgreich erstellt und kann in Kürze abgerufen werden")
      end
    end

    context 'when it fails' do
      let(:context) { double(:context, success?: false, message: 'an_error_message') }

      it 'redirects the user to the booking url' do
        create_request = post :create, params: params

        expect(create_request).to redirect_to(booking_path(id: 'a_booking_id'))
      end

      it 'sets an alert info message' do
        post :create, params: params

        expect(flash[:error]).to eq('an_error_message')
      end
    end
  end

  describe '[GET] new' do
    let(:booking_invoice) { instance_double(BookingInvoice, booking: booking) }
    let(:booking) { instance_double(Booking, id: 'a_booking_id') }
    let(:initialize_booking_invoice_interactor) do
      double(:initialize_booking_invoice_interactor,
        document: booking_invoice,
        created_booking_resource_skus: [],
        updated_booking_resource_skus: [],
        canceled_booking_resource_skus: [],
        created_booking_credits: [],
        updated_booking_credits: [],
        removed_booking_credits: [],
        created_booking_resource_sku_groups: [],
        updated_booking_resource_sku_groups: [],
        canceled_booking_resource_sku_groups: [],
        created_booking_resource_skus_price_info: {},
        updated_booking_resource_skus_price_info: {},
        canceled_booking_resource_skus_price_info: {},
        created_booking_credits_price_info: {},
        updated_booking_credits_price_info: {},
        removed_booking_credits_price_info: {},
        created_booking_resource_sku_groups_price_info: {},
        updated_booking_resource_sku_groups_price_info: {},
        canceled_booking_resource_sku_groups_price_info: {}
      )
    end

    before do
      allow(booking_invoice).to receive(:decorate) { booking_invoice }
      allow(BookingInvoicesService).to receive(:new)
      allow(Documents::Initialize::BookingInvoice).to receive(:call) do
        initialize_booking_invoice_interactor
      end
    end

    it 'initializes the booking invoice' do
      get :new, params: { booking_id: 'a_booking_id' }

      expect(Documents::Initialize::BookingInvoice).to have_received(:call).with(booking_id: 'a_booking_id')
    end

    it 'renders booking_invoices#new with new booking_invoice' do
      get :new, params: {booking_id: 'a_booking_id'}

      expect(response).to render_template('booking_invoices/new')
    end
  end
end
