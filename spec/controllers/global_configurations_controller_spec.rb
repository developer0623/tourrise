# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::GlobalConfigurationsController, type: :controller do
  login_user

  describe '[POST] create' do
    let(:global_configuration) { instance_double(GlobalConfiguration, company_name: "tourrise GmbH", save: true) }
    let(:global_configurations_params) do
      {
        "company_name" => "tourrise GmbH"
      }
    end

    let(:params) do
      {
        "global_configuration" => {
          "company_name" => "tourrise GmbH"
        }
      }
    end

    before do
      allow(GlobalConfiguration).to receive(:new) { global_configuration }
    end

    it 'assigns a new instance' do
      post :create, params: params

      expect(GlobalConfiguration).to have_received(:new).with(global_configurations_params)
    end

    it 'redirects to the edit view' do
      post :create, params: params

      expect(response).to redirect_to(edit_settings_global_configuration_path(global_configuration))
    end

    context 'with failure' do
      let(:global_configuration) { instance_double(GlobalConfiguration, company_name: "tourrise GmbH", save: false) }

      it 'sets the error message' do
        post :create, params: params

        expect(flash[:error]).to eq(I18n.t("settings.global_configurations.create.error"))
      end

      it 'renders the #new template' do
        post :create, params: params

        expect(response).to render_template('global_configurations/new')
      end
    end
  end

  describe '[GET] new' do
    let(:global_configuration) { instance_double(GlobalConfiguration, company_name: "tourrise GmbH") }

    before do
      allow(GlobalConfiguration).to receive(:new) { global_configuration }
    end

    it 'initializes a new instance' do
      get :new, params: {}

      expect(GlobalConfiguration).to have_received(:new)
    end

    context 'when an instance of GlobalConfiguration already exists' do
      before do
        allow(GlobalConfiguration).to receive(:any?) { global_configuration }
        allow(GlobalConfiguration).to receive(:last) { global_configuration }
      end

      it 'redirects to the edit page' do
        get :new, params: {}

        expect(response).to redirect_to(edit_settings_global_configuration_path(global_configuration))
      end
    end
  end

  describe '[GET] edit' do
    before do
      allow(GlobalConfiguration).to receive(:last)
    end

    it 'loads the existing configurations' do
      get :edit, params: { id: 'last_id' }

      expect(GlobalConfiguration).to have_received(:last)
    end
  end

  describe '[PATCH] update' do
    let(:global_configuration) { instance_double(GlobalConfiguration, company_name: "tourrise GmbH", id: 'last_id') }
    let(:global_configurations_params) do
      {
        "company_name" => "tourrise GmbH"
      }
    end

    let(:params) do
      {
        "id" => "last_id",
        "global_configuration" => {
          "company_name" => "tourrise GmbH"
        }
      }
    end

    before do
      allow(GlobalConfiguration).to receive(:find) { global_configuration }
      allow(global_configuration).to receive(:update) { true }
    end

    it 'finds the existing configuration' do
      patch :update, params: params

      expect(GlobalConfiguration).to have_received(:find).with('last_id')
    end

    it 'updates with the passed params and redirects to #edit with the success message' do
      patch :update, params: params

      expect(global_configuration).to have_received(:update).with(global_configurations_params)
      expect(response).to redirect_to(edit_settings_global_configuration_path(global_configuration))
      expect(flash[:notice]).to eq(I18n.t("settings.global_configurations.update.success"))
    end

    context 'with failure' do
      before do
        allow(global_configuration).to receive(:update) { false }
      end

      it 'renders #edit and sets the error message' do
        patch :update, params: params

        expect(response).to render_template('global_configurations/edit')
        expect(flash[:error]).to eq(I18n.t("settings.global_configurations.update.error"))
      end
    end
  end
end
