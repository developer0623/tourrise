require 'rails_helper'

describe Easybill::InvoicesController, type: :controller do
  login_user

  routes { Easybill::Engine.routes }

  let(:invoice_id) { 1 }
  let(:context) { double(:context) }

  describe '[GET] show' do
    before do
      allow(Easybill::DownloadInvoice).to receive(:call) { context }
      allow(context).to receive(:success?) { true }
      allow(context).to receive(:document) { 'pdf document data' }
    end

    it 'calls the download invoice interactor' do
      get :show, params: { id: invoice_id }, format: :pdf

      expect(Easybill::DownloadInvoice).to have_received(:call).with(invoice_id: '1')
    end

    it 'responds with binary data' do
      get :show, params: { id: invoice_id }, format: :pdf

      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
    end

    it 'responds with the filename' do
      get :show, params: { id: invoice_id }, format: :pdf

      expect(response.headers['Content-Disposition']).to include('attachment; filename="Rechnung.pdf"')
    end

    it 'responds with the correct content type' do
     get :show, params: { id: invoice_id }, format: :pdf

     expect(response.headers['Content-Type']).to eq('application/pdf')
    end

    it 'responds with pdf content' do
      get :show, params: { id: invoice_id }, format: :pdf

      expect(response.body).to eq('pdf document data')
    end
  end
end
