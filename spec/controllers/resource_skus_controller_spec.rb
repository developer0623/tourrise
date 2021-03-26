require 'rails_helper'

RSpec.describe ResourceSkusController, type: :controller do
  login_user

  describe '[GET] show' do
    let(:resource_sku ) { FactoryBot.create(:resource_sku) }

    it 'render resource sku show with resource' do
      get :show, params: { id: resource_sku.id, resource_id: resource_sku.resource.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:resource_sku)).to eq(resource_sku)
      expect(response).to render_template('resource_skus/show')
    end
  end

  describe '[GET] edit' do
    let(:resource_sku) { FactoryBot.create(:resource_sku) }
    let(:resource_sku_context) { double(:context, success?: success, resource_sku: resource_sku) }

    let(:success) { true }

    before do
      allow(ResourceSkus::LoadResourceSku).to receive(:call).and_return(resource_sku_context)
    end

    it 'render resource sku show with resource' do
      get :edit, params: { id: resource_sku.id, resource_id: resource_sku.resource.id }

      expect(response).to have_http_status(:success)
      expect(ResourceSkus::LoadResourceSku).to have_received(:call).with(resource_sku_id: resource_sku.id.to_s)
      expect(assigns(:resource_sku)).to eq(resource_sku)
      expect(response).to render_template('resource_skus/edit')
    end
  end

  describe '[PUT] update' do
    let(:resource_sku) { FactoryBot.create(:resource_sku) }
    let(:context) { double(:context, success?: success, resource_sku: resource_sku, message: 'alert') }
    let(:params) { { 'name': 'test resource' } }
    let(:success) { true }

    before do
      allow(ResourceSkus::UpdateResourceSku).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      put :update, params: { id: resource_sku.id, resource_sku: params, resource_id: resource_sku.resource.id }

      expect(ResourceSkus::UpdateResourceSku).to have_received(:call).with(resource_sku_id: resource_sku.id.to_s, params: params)
    end

    context 'when it succeeds' do
      it 'redirect to resource url' do
        put :update, params: { id: resource_sku.id, resource_sku: params, resource_id: resource_sku.resource.id }

        expect(response).to redirect_to(resource_path(resource_sku.resource))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      let(:success) { false }

      it 'render resource edit with resource sku' do
        put :update, params: { id: resource_sku.id, resource_sku: params, resource_id: resource_sku.resource.id }

        expect(response).to render_template('resource_skus/edit')
        expect(assigns(:resource_sku)).to eq(resource_sku)
        expect(assigns(:resource_sku).name).not_to eq(params[:name])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
