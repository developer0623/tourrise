# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frontoffice::InquiriesController, type: :controller do
  login_user

  let(:product_sku_context) { double(:context, success?: true, product_sku: product_sku) }
  let(:product_sku) { instance_double(ProductSku, id: 'product_sku_id') }

  before do
    allow(Frontoffice::LoadProductSku).to receive(:call) { product_sku_context }
  end

  describe "[GET] new" do
    let(:booking_inquiry_form) { instance_double(Frontoffice::BookingInquiryForm) }

    before do
      allow(Frontoffice::BookingInquiryForm).to receive(:new) { booking_inquiry_form }
    end

    it 'loads the product sku' do
      get :new, params: { product_sku_handle: 'product_sku_handle' }

      expect(Frontoffice::LoadProductSku).to have_received(:call).with(product_sku_handle: 'product_sku_handle')
    end

    context 'when the product_sku_handle does not exist' do
      let(:product_sku_context) { double(:context, success?: false) }

      it 'renders a not found page' do
        get :new, params: { product_sku_handle: 'product_sku_handle' }

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'initializes a new booking inquiry form' do
      get :new, params: { product_sku_handle: 'product_sku_handle' }

      expect(Frontoffice::BookingInquiryForm).to have_received(:new).with(product_sku_id: 'product_sku_id')
    end

    it 'renders inquiries new' do
      get :new, params: { product_sku_handle: 'product_sku_handle' }

      expect(response).to have_http_status(:success)
      expect(response).to render_template('frontoffice/inquiries/new')
    end
  end

  describe "[POST] create" do
    let(:context) { double(:context, success?: true) }

    before do
      allow(Frontoffice::Inquiries::CreateInquiry).to receive(:call) { context }
    end

    let(:create_params) do
      {
        product_sku_handle: 'product_sku_handle',
        booking: {
          first_name: "first_name",
          last_name: "last_name",
          email: "email",
          wishyouwhat: "somerandomtext",
          product_sku_id: "product_sku_id",
          starts_on: "starts_on",
          ends_on: "ends_on",
          adults: "adults",
          kids: "kids",
          babies: "babies",
          other_data: "other_data"
        }
      }
    end

    it 'loads the product sku' do
      post :create, params: create_params

      expect(Frontoffice::LoadProductSku).to have_received(:call).with(product_sku_handle: 'product_sku_handle')
    end

    context 'when the product_sku_handle does not exist' do
      let(:product_sku_context) { double(:context, success?: false) }

      it 'renders a not found page' do
        post :create, params: create_params

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'calls the create inquiry interactor' do
      post :create, params: create_params

      expected_booking_params = {
        "wishyouwhat" => "somerandomtext",
        "product_sku_id" => "product_sku_id",
        "starts_on" => "starts_on",
        "ends_on" => "ends_on",
        "adults" => "adults",
        "kids" => "kids",
        "babies" => "babies",
        "first_name" => "first_name",
        "last_name" => "last_name",
        "email" => "email",
      }

      expect(Frontoffice::Inquiries::CreateInquiry).to have_received(:call).with(params: expected_booking_params, current_user: FrontofficeUser)
    end

    context 'when the creation fails' do
      let(:context) { double(:context, success?: false, message: 'an_error_message') }
      let(:booking_inquiry_form) { instance_double(Frontoffice::BookingInquiryForm, valid?: false) }

      before do
        allow(Frontoffice::BookingInquiryForm).to receive(:new) { booking_inquiry_form }
      end

      it 'initializes a booking inquiry form' do
        post :create, params: create_params

        expected_booking_params = {
          "wishyouwhat" => "somerandomtext",
          "product_sku_id" => "product_sku_id",
          "starts_on" => "starts_on",
          "ends_on" => "ends_on",
          "adults" => "adults",
          "kids" => "kids",
          "babies" => "babies",
          "first_name" => "first_name",
          "last_name" => "last_name",
          "email" => "email",
        }

        expect(Frontoffice::BookingInquiryForm).to have_received(:new).with(expected_booking_params)
      end

      it 'sets an error message' do
        post :create, params: create_params

        expect(flash[:error]).to eq("an_error_message")
      end

      it 'renders inquiries new' do
        post :create, params: create_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('frontoffice/inquiries/new')
      end
    end
  end

  describe "[GET] success" do
    it 'loads the product sku' do
      get :success, params: { product_sku_handle: 'product_sku_handle' }

      expect(Frontoffice::LoadProductSku).to have_received(:call).with(product_sku_handle: 'product_sku_handle')
    end

    context 'when the product_sku_handle does not exist' do
      let(:product_sku_context) { double(:context, success?: false) }

      it 'renders a not found page' do
        get :success, params: { product_sku_handle: 'product_sku_handle' }

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'renders inquiries success' do
      get :success, params: { product_sku_handle: 'product_sku_handle' }

      expect(response).to have_http_status(:success)
      expect(response).to render_template('frontoffice/inquiries/success')
    end
  end
end
