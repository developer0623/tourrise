require "rails_helper"

RSpec.describe Settings::FrontofficeSettingsController, type: :controller do
  login_user

  describe '[GET] new' do
    let(:frontoffice_setting) { instance_double(FrontofficeSetting, id: 1) }

    before do
      allow(FrontofficeSetting).to receive(:last) { nil }
      allow(FrontofficeSetting).to receive(:new) { frontoffice_setting }
    end

    it 'initializes a new instance, when no settings are present' do
      get :new, params: { locale: I18n.locale }

      expect(FrontofficeSetting).to have_received(:new)
      expect(response).to render_template("new")
    end

    context 'when settings are already present' do
      before do
        allow(FrontofficeSetting).to receive(:any?) { frontoffice_setting }
        allow(FrontofficeSetting).to receive(:last) { frontoffice_setting }
      end

      it 'redirects to edit path' do
        get :new, params: { locale: I18n.locale }

        expect(response).to redirect_to :action => :edit, :id => frontoffice_setting
      end
    end
  end

  describe '[GET] edit' do
    let(:frontoffice_setting) { instance_double(FrontofficeSetting) }

    before do
      allow(FrontofficeSetting).to receive(:last) { frontoffice_setting }
    end

    it 'renders the existing frontoffice_settings' do
      get :edit, params: { locale: I18n.locale, id: frontoffice_setting }

      expect(FrontofficeSetting).to have_received(:last)
      expect(response).to render_template("edit")
    end
  end

  describe '[POST] create' do
    let(:frontoffice_setting) { instance_double(FrontofficeSetting) }
    let(:create_params) do
      {
        "locale" => I18n.locale,
        "frontoffice_setting" => {
          "company_name" => "a_company",
          "address_line_1" => "a_street"
        }
      }
    end

    before do
      allow(FrontofficeSetting).to receive(:new) { frontoffice_setting }
      allow(frontoffice_setting).to receive(:save) { true }
    end

    it 'saves a new frontoffice_settings instance' do
      post :create, params: create_params

      expect(FrontofficeSetting).to have_received(:new)
      expect(flash[:notice]).to eq(I18n.t("settings.frontoffice_settings.create.success"))
    end

    context 'when settings could not be saved' do
      before do
        allow(frontoffice_setting).to receive(:save) { false }
      end

      it 'sets the error message' do
        post :create, params: create_params

        expect(flash[:error]).to eq(I18n.t("settings.frontoffice_settings.create.error"))
        expect(response).to render_template("new")
      end
    end
  end

  describe '[PATCH] update' do
    let(:frontoffice_setting) { instance_double(FrontofficeSetting, id: 1) }
    let(:update_params) do
      {
        "locale" => I18n.locale,
        "frontoffice_setting" => {
          "company_name" => "a_company",
          "address_line_1" => "a_street"
        }
      }
    end

    before do
      allow(FrontofficeSetting).to receive(:find) { frontoffice_setting }
      allow(frontoffice_setting).to receive(:update) { true }
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'finds the current frontoffice_settings' do
      patch :update, params: { id: frontoffice_setting.id, frontoffice_setting: update_params }

      expect(FrontofficeSetting).to have_received(:find)
    end

    it 'updates the existing settings and shows the success message' do
      patch :update, params: { id: frontoffice_setting.id, frontoffice_setting: update_params }

      expect(frontoffice_setting).to have_received(:update)
      expect(flash[:notice]).to eq(I18n.t("settings.frontoffice_settings.update.success"))
    end

    context 'when settings could not be updated' do
      before do
        allow(frontoffice_setting).to receive(:update) { false }
      end

      it 'shows the error message and renders edit page' do
        patch :update, params: { id: frontoffice_setting.id, frontoffice_setting: update_params }

        expect(flash[:error]).to eq(I18n.t("settings.frontoffice_settings.update.error"))
        expect(response).to render_template("edit")
      end
    end
  end
end
