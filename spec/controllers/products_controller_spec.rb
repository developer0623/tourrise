# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  login_user

  describe '[POST] create' do
    let(:context) { double(:context, success?: success, product: product) }
    let(:params) { { 'name' => 'test product' } }
    let(:success) { true }

    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save

      allow(Products::CreateProduct).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      post :create, params: { product: params }

      expect(Products::CreateProduct).to have_received(:call).with(params: params)
    end

    context 'when it succeeds' do
      it 'redirect to product url' do
        post :create, params: { product: params }

        expect(response).to redirect_to(product_path(product))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      let(:success) { false }

      it 'render product new with product' do
        post :create, params: { product: params }

        expect(response).to render_template('products/new')
        expect(assigns(:product)).to eq(product)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '[GET] show' do
    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save
    end

    it 'render product show with product' do
      get :show, params: { id: product.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:product)).to eq(product)
      expect(response).to render_template('products/show')
    end
  end

  describe '[GET] new' do
    it 'render product show with product' do
      get :new, params: {}

      expect(response).to have_http_status(:success)
      expect(assigns(:product)).to be_a_new(Product)
      expect(response).to render_template('products/new')
    end
  end

  describe '[GET] edit' do
    let(:context) { double(:context, success?: success, product: product) }
    let(:success) { true }

    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save

      allow(Products::LoadProduct).to receive(:call).and_return(context)
    end

    it 'render product show with product' do
      get :edit, params: { id: product.id}

      expect(response).to have_http_status(:success)
      expect(Products::LoadProduct).to have_received(:call).with(product_id: product.id.to_s)
      expect(assigns(:product)).to eq(product)
      expect(response).to render_template('products/edit')
    end
  end

  describe '[PUT] update' do
    let(:context) { double(:context, success?: success, product: product) }
    let(:params) { { 'name' => 'test product' } }
    let(:success) { true }

    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save

      allow(Products::UpdateProduct).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      put :update, params: { id: product.id, product: params }

      expect(Products::UpdateProduct).to have_received(:call).with(product: product, params: params)
    end

    context 'when it succeeds' do
      it 'redirect to product url' do
        put :update, params: { id: product.id, product: params }

        expect(response).to redirect_to(product_path(product))
        expect(response).to have_http_status(:found)
      end
    end

    context 'when it fails' do
      let(:success) { false }

      before do
        allow(context).to receive(:message)
      end

      it 'render product new with product' do
        put :update, params: { id: product.id, product: params }

        expect(response).to render_template('products/edit')
        expect(assigns(:product)).to eq(product)
        expect(assigns(:product).name).not_to eq(params[:name])
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '[GET] index' do
    let(:context) { double(:context, products: Product.all) }
    let(:params) { { q: 'test', sort_by: 'name', sort_order: 'desc' } }
    let(:success) { true }

    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save

      allow(Products::ListProducts).to receive(:call).and_return(context)
    end

    it 'calls the interactor' do
      get :index, params: params

      expect(Products::ListProducts).to have_received(:call).with(
        page: nil,
        filter: params.slice(:q),
        sort: {
          by: params[:sort_by],
          order: params[:sort_order]
        }
      )
    end

    it 'render list of products' do
      get :index, params: params

      expect(assigns(:products)).to eq(context.products)
      expect(response).to render_template('products/index')
      expect(response).to have_http_status(:success)
    end
  end
end
