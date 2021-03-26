# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ResourcesController, type: :controller do
  login_user

  describe '[POST] create' do
    let(:context) { double(:context, success?: success, resource: resource, message: 'alert') }
    let(:resource) { FactoryBot.create(:resource) }
    let(:params) { { 'name': 'test resource' } }
    let(:success) { true }

    before do
      allow(Resources::CreateResource).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      post :create, params: { resource: params }

      expect(Resources::CreateResource).to have_received(:call).with(params: ActionController::Parameters.new(params).permit(:name))
    end

    context 'when it succeeds' do
      it 'redirect to resource url' do
        post :create, params: { resource: params }

        expect(response).to redirect_to(resource_path(resource))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      let(:success) { false }

      it 'render resource new with resource' do
        post :create, params: { resource: params }

        expect(response).to render_template('resources/new')
        expect(assigns(:resource)).to eq(resource)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '[GET] show' do
    let(:resource) { FactoryBot.create(:resource) }

    it 'render resource show with resource' do
      get :show, params: { id: resource.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:resource)).to eq(resource)
      expect(response).to render_template('resources/show')
    end
  end

  describe '[GET] new' do
    it 'render resource show with resource' do
      get :new, params: {}

      expect(response).to have_http_status(:success)
      expect(assigns(:resource)).to be_a_new(Resource)
      expect(response).to render_template('resources/new')
    end
  end

  describe '[GET] edit' do
    let(:resource) { FactoryBot.create(:resource) }
    let(:context) { double(:context, success?: success, resource: resource) }
    let(:success) { true }

    before do
      allow(Resources::LoadResource).to receive(:call).and_return(context)
    end

    it 'render resource show with resource' do
      get :edit, params: { id: resource.id}

      expect(response).to have_http_status(:success)
      expect(Resources::LoadResource).to have_received(:call).with(resource_id: resource.id.to_s)
      expect(assigns(:resource)).to eq(resource)
      expect(response).to render_template('resources/edit')
    end
  end

  describe '[PUT] update' do
    let(:context) { double(:context, success?: success, resource: resource, message: 'alert') }
    let(:resource) { FactoryBot.create(:resource) }
    let(:params) { { 'name': 'test resource' } }
    let(:success) { true }

    before do
      allow(Resources::UpdateResource).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      put :update, params: { id: resource.id, resource: params }

      expect(Resources::UpdateResource).to have_received(:call).with(resource_id: resource.id.to_s, params: params)
    end

    context 'when it succeeds' do
      it 'redirect to resource url' do
        put :update, params: { id: resource.id, resource: params }

        expect(response).to redirect_to(resource_path(resource))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      let(:success) { false }

      it 'render resource new with resource' do
        put :update, params: { id: resource.id, resource: params }

        expect(response).to render_template('resources/edit')
        expect(assigns(:resource)).to eq(resource)
        expect(assigns(:resource).name).not_to eq(params[:name])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '[GET] index' do
    let(:context) { double(:context, resources: Resource.all) }
    let(:resource) { FactoryBot.create(:resource, name: 'test resource') }
    let(:params) { { q: 'test', resource_type_id: nil, sort_by: 'name', sort_order: 'desc' } }
    let(:success) { true }

    before do
      allow(Resources::ListResources).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      get :index, params: params

      expect(Resources::ListResources).to have_received(:call).with(
        page: nil,
        filter: params.slice(:q, :resource_type_id),
        sort: {
          by: params[:sort_by],
          order: params[:sort_order]
        }
      )
    end

    it 'render list of resources' do
      get :index, params: params

      expect(assigns(:resources)).to eq(context.resources)
      expect(response).to render_template('resources/index')
      expect(response).to have_http_status(:success)
    end
  end

  describe '[DELETE] destroy' do
    let(:context) { double(:context, success?: success, resource: resource, message: 'alert') }
    let(:resource) { FactoryBot.create(:resource) }
    let(:success) { true }

    before do
      allow(Resources::DestroyResource).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      put :destroy, params: { id: resource.id }

      expect(Resources::DestroyResource).to have_received(:call).with(resource_id: resource.id.to_s)
    end

    context 'when it succeeds' do
      it 'redirect to resource url' do
        put :destroy, params: { id: resource.id }

        expect(response).to redirect_to(resources_path)
        expect(response).to have_http_status(:see_other)
      end
    end

    context 'when it fails' do
      let(:success) { false }

      it 'redirect to resource page' do
        put :destroy, params: { id: resource.id }

        expect(response).to redirect_to(resource_path(resource))
        expect(response).to have_http_status(:found)
      end
    end
  end
end
