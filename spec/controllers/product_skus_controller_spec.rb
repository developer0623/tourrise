require 'rails_helper'

RSpec.describe ProductSkusController, type: :controller do
  login_user

  describe '[GET] edit' do
    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save
    end

    it 'render product sku show with product' do
      get :edit, params: { id: product.product_skus.first.id, product_id: product.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:product)).to eq(product)
      expect(assigns(:product_sku)).to eq(product.product_skus.first)
      expect(response).to render_template('product_skus/edit')
    end
  end

  describe '[PUT] update' do
    let(:product) { FactoryBot.build(:product) }
    let(:product_sku) { FactoryBot.build(:product_sku, name: 'product_sku_name') }

    before do
      product.product_skus << product_sku
      product.save
    end

    let(:params) do
      {
        id: product_sku.id,
        product_id: product.id,
        product_sku: {
          name: 'changed_product_sku_name'
        }
      }
    end

    context 'when it succeeds' do
      it 'redirect to product url' do
        put :update, params: params

        expect(response).to redirect_to(product_path(product))
      end

      it 'has the product_sku variable assigned' do
        put :update, params: params

        expect(assigns(:product_sku)).to eq(product_sku)
      end

      it 'changed the name' do
        put :update, params: params

        expect(assigns(:product_sku).name).to eq('changed_product_sku_name')
      end
    end

    context 'when it fails' do
      let(:params) do
        {
          id: product_sku.id,
          product_id: product.id,
          product_sku: {
            name: nil
          }
        }
      end

      it 'renders the edit template' do
        put :update, params: params

        expect(response).to render_template('product_skus/edit')
      end

      it 'has the product_sku instance variable' do
        put :update, params: params

        expect(assigns(:product_sku)).to eq(product_sku)
      end

      it 'does not clear the name' do
        put :update, params: params

        updated_product_sku = assigns(:product_sku).reload

        expect(updated_product_sku.name).to eq('product_sku_name')
      end

      it 'sets the error flash message' do
        put :update, params: params

        expect(flash[:error]).to eq(["Name muss ausgefüllt werden"])
      end

      it 'is a success' do
        put :update, params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
