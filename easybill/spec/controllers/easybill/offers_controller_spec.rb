require 'rails_helper'

describe Easybill::OffersController, type: :controller do
  login_user

  routes { Easybill::Engine.routes }

  let(:offer_id) { 1 }
  let(:context) { double(:context) }

  describe '[GET] show' do
    before do
      allow(Easybill::DownloadOffer).to receive(:call) { context }
      allow(context).to receive(:success?) { true }
      allow(context).to receive(:document) { 'pdf document data' }
    end

    it 'calls the download offer interactor' do
      get :show, params: { id: offer_id }, format: :pdf

      expect(Easybill::DownloadOffer).to have_received(:call).with(offer_id: '1')
    end

    it 'responds with binary data' do
      get :show, params: { id: offer_id }, format: :pdf

      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
    end

    it 'responds with the filename' do
      get :show, params: { id: offer_id }, format: :pdf

      expect(response.headers['Content-Disposition']).to include('attachment; filename="Angebot.pdf"')
    end

    it 'responds with the correct content type' do
     get :show, params: { id: offer_id }, format: :pdf

     expect(response.headers['Content-Type']).to eq('application/pdf')
    end

    it 'responds with pdf content' do
      get :show, params: { id: offer_id }, format: :pdf

      expect(response.body).to eq('pdf document data')
    end
  end
end
