# frozen_string_literal: true

module Settings
  class CustomAttributesController < ApplicationController
    before_action :set_custom_attribute, except: %i[index create new]

    def index
      @custom_attributes = if params[:q].present?
                             CustomAttribute.with_translations(I18n.locale).where("LOWER(custom_attribute_translations.name) LIKE :query", query: "%#{params[:q]}%")
                           else
                             CustomAttribute.all
                           end
    end

    def create
      @custom_attribute = CustomAttribute.new(custom_attribute_params)

      if @custom_attribute.save
        flash[:success] = I18n.t("settings.custom_attributes.create.success")
        redirect_to settings_custom_attributes_path
      else
        flash.now[:error] = @custom_attribute.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end

    def new
      @custom_attribute = CustomAttribute.new
    end

    def edit; end

    def update
      @custom_attribute.assign_attributes(custom_attribute_params)

      if @custom_attribute.save
        flash[:success] = I18n.t("settings.custom_attributes.update.success")
        redirect_to settings_custom_attributes_path
      else
        flash.now[:error] = @custom_attribute.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @custom_attribute.destroy
        flash[:success] = I18n.t("settings.custom_attributes.destroy.success")
        redirect_to settings_custom_attributes_path
      else
        flash.now[:error] = @custom_attribute.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def custom_attribute_params
      params.require(:custom_attribute).permit(:name, :field_type)
    end

    def set_custom_attribute
      @custom_attribute = CustomAttribute.find(params[:id])
    end
  end
end
