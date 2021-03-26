# frozen_string_literal: true

module Settings
  class FrontofficeSettingsController < ApplicationController
    def new
      redirect_to edit_settings_frontoffice_setting_path(FrontofficeSetting.last) if FrontofficeSetting.any?

      @frontoffice_setting = FrontofficeSetting.new
    end

    def create
      @frontoffice_setting = FrontofficeSetting.new(frontoffice_setting_params)

      if @frontoffice_setting.save
        redirect_to edit_settings_frontoffice_setting_path(@frontoffice_setting), notice: I18n.t("settings.frontoffice_settings.create.success")
      else
        flash.now[:error] = I18n.t("settings.frontoffice_settings.create.error")
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @frontoffice_setting = FrontofficeSetting.last
    end

    def update
      @frontoffice_setting = FrontofficeSetting.find(params[:id])

      if @frontoffice_setting.update(frontoffice_setting_params)
        flash[:notice] = I18n.t("settings.frontoffice_settings.update.success")
        redirect_to request.referer
      else
        flash[:error] = I18n.t("settings.frontoffice_settings.update.error")
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def frontoffice_setting_params
      params.require(:frontoffice_setting).permit(
        :company_name,
        :address_line_1,
        :address_line_2,
        :zip_code,
        :city,
        :state,
        :country,
        :phone,
        :email,
        :vat_id,
        :external_terms_of_service_url,
        :external_privacy_policy_url,
        :external_document_preview_url
      )
    end
  end
end
