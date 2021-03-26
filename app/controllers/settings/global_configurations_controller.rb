# frozen_string_literal: true

module Settings
  class GlobalConfigurationsController < ApplicationController
    def new
      redirect_to edit_settings_global_configuration_path(GlobalConfiguration.last) if GlobalConfiguration.any?

      @global_configuration = GlobalConfiguration.new
    end

    def create
      @global_configuration = GlobalConfiguration.new(global_configuration_params)

      if @global_configuration.save
        redirect_to edit_settings_global_configuration_path(@global_configuration), notice: I18n.t("settings.global_configurations.create.success")
      else
        flash.now[:error] = I18n.t("settings.global_configurations.create.error")
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @global_configuration = GlobalConfiguration.last
    end

    def update
      @global_configuration = GlobalConfiguration.find(params[:id])

      if @global_configuration.update(global_configuration_params)
        redirect_to edit_settings_global_configuration_path(@global_configuration), notice: I18n.t("settings.global_configurations.update.success")
      else
        flash[:error] = I18n.t("settings.global_configurations.update.error")
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def global_configuration_params
      params.require(:global_configuration).permit(
        :company_name,
        :contact_phone,
        :contact_email,
        :partial_payment_percentage,
        :term_of_first_payment,
        :term_of_final_payment
      )
    end
  end
end
