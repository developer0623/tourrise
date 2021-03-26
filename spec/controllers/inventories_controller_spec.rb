# frozen_string_literal: true

require 'rails_helper'
RSpec.describe InventoriesController, type: :controller do
  login_user

  describe '[POST] create' do
    let(:context) { double(:context, success?: success, inventory: inventory) }
    let(:params) { { 'name': 'test inventory', 'description': 'text description', inventory_type: 'quantity' } }
    let(:invalid_params) { { 'name': '', 'description': 'text description', inventory_type: 'quantity' } }

    context 'when it succeeds' do
      it 'redirect to inventory url' do
        post :create, params: { inventory: params }

        expect(response).to redirect_to(inventory_path(assigns(:inventory)))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      it 'render inventory new with inventory' do
        post :create, params: { inventory: invalid_params }

        expect(response).to render_template('inventories/new')
        expect(assigns(:inventory)).not_to be_persisted
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '[GET] show' do
    let(:inventory) { FactoryBot.create(:inventory) }

    it 'render inventory show with inventory' do
      get :show, params: { id: inventory.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).to eq(inventory)
      expect(response).to render_template('inventories/show')
    end
  end

  describe '[GET] new' do
    it 'render inventory show with inventory' do
      get :new, params: {}

      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).to be_a_new(Inventory)
      expect(response).to render_template('inventories/new')
    end
  end

  describe '[GET] edit' do
    let(:inventory) { FactoryBot.create(:inventory) }

    it 'render inventory show with inventory' do
      get :edit, params: { id: inventory.id}

      expect(response).to have_http_status(:success)
      expect(assigns(:inventory)).to eq(inventory)
      expect(response).to render_template('inventories/edit')
    end
  end

  describe '[PUT] update' do
    let(:params) { { 'name': 'test inventory' } }
    let(:invalid_params) { { 'name': "" } }

    let(:inventory) { FactoryBot.create(:inventory) }

    context 'when it succeeds' do
      it 'redirect to inventory url' do
        put :update, params: { id: inventory.id, inventory: params }

        expect(assigns(:inventory).name).to eq('test inventory')
        expect(response).to redirect_to(inventory_path(inventory))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      it 'render inventory new with inventory' do
        put :update, params: { id: inventory.id, inventory: invalid_params }

        expect(response).to render_template('inventories/edit')
        expect(assigns(:inventory)).to eq(inventory)
        expect(assigns(:inventory).name).not_to eq(params[:name])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '[GET] index' do
    let(:context) { double(:context, inventories: Inventory.all) }
    let(:params) { { q: 'test', sort_by: 'name', sort_order: 'desc' } }
    let(:success) { true }

    let(:inventory) { FactoryBot.create(:inventory) }

    before do
      allow(Inventories::ListInventories).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      get :index, params: params

      expect(Inventories::ListInventories).to have_received(:call).with(
        page: nil,
        filter: params.slice(:q),
        sort: {
          by: params[:sort_by],
          order: params[:sort_order]
        }
      )
    end

    it 'render list of inventories' do
      get :index, params: params

      expect(assigns(:inventories)).to eq(context.inventories)
      expect(response).to render_template('inventories/index')
      expect(response).to have_http_status(:success)
    end
  end
end
