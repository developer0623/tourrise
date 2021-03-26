require 'rails_helper'

RSpec.describe "cancellation reason settings", type: :request do
  let(:user) { create(:user) }
  let(:cancellation_reason_params) { attributes_for(:cancellation_reason) }
  let(:update_cancellation_reason_params) { cancellation_reason_params.merge(name: "Updated Standard") }

  before do
    sign_in user
  end

  describe "visiting, creating, and editing a cancellation reason" do
    it 'works' do
      get settings_cancellation_reasons_path(locale: I18n.locale)

      expect(response.body).to include(I18n.t("settings.cancellation_reasons.index.title"))

      get new_settings_cancellation_reason_path(locale: I18n.locale)

      expect(response.body).to include(I18n.t("settings.cancellation_reasons.new.title"))

      expect {
        post settings_cancellation_reasons_path(locale: I18n.locale, cancellation_reason: cancellation_reason_params)
      }.to change { CancellationReason.count }.by(1)

      cancellation_reason = CancellationReason.last

      expect(response).to redirect_to(settings_cancellation_reasons_path(locale: I18n.locale))

      get edit_settings_cancellation_reason_path(locale: I18n.locale, id: cancellation_reason.id)

      expect(response.body).to include(I18n.t("settings.cancellation_reasons.edit.title", name: cancellation_reason.name))

      expect {
        put settings_cancellation_reason_path(locale: I18n.locale, id: cancellation_reason.id, cancellation_reason: update_cancellation_reason_params)
      }.to change { cancellation_reason.reload.name }.from("Standard").to("Updated Standard")

      expect(response).to redirect_to(settings_cancellation_reasons_path(locale: I18n.locale))

      delete settings_cancellation_reason_path(locale: I18n.locale, id: cancellation_reason.id)

      expect(cancellation_reason.reload).to be_deleted
    end
  end
end
