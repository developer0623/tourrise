require 'rails_helper'

describe Easybill::Api::V1::OffersController, type: :controller do
  routes { Easybill::Engine.routes }

  describe '[GET] show' do
    let(:booking_offer_id) { 'booking_offer_id' }
    let(:offer) do
      Easybill::Offer.new(
        booking_offer_id: 1,
        external_id: 'external_id'
      )
    end
    let(:context) { double(:context) }
    let(:authentication_context) { double(:context, failure?: false) }
    let(:api_service) { double(:api_service) }

    before do
      allow(Easybill::Api::V1::AuthenticateUser).to receive(:call) { authentication_context }
      allow(Easybill::ApiService).to receive(:new) { api_service }
      allow(api_service).to receive(:find_document) { 'document_data' }
      allow(Easybill::LoadOffer).to receive(:call) { context }
      allow(context).to receive(:success?) { true }
      allow(context).to receive(:offer) { offer }
    end

    it 'calls the load offer interactor' do
      get :show, params: { booking_offer_id: booking_offer_id }, format: :json

      expect(Easybill::LoadOffer).to have_received(:call).with(booking_offer_id: 'booking_offer_id')
    end

    it 'responds with the jsonapi serialized offer attributes' do
      get :show, params: { booking_offer_id: booking_offer_id }, format: :json

      document = JSON.parse(response.body)

      exptected_attributes = {
        'booking_offer_id' => 1,
        'external_id' => 'external_id',
        'created_at' => nil,
        'updated_at' => nil,
        'document' => 'document_data'
      }
      expect(document['data']['attributes']).to eq(exptected_attributes)
    end
  end
end
