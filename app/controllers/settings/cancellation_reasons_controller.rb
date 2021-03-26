# frozen_string_literal: true

module Settings
  class CancellationReasonsController < ApplicationController
    def index
      @cancellation_reasons = CancellationReason.all
      @cancellation_reasons = @cancellation_reasons.where("name LIKE ?", "%#{search_term}%") if search_term.present?
    end

    def new
      @cancellation_reason = CancellationReason.new
    end

    def create
      @cancellation_reason = CancellationReason.new(permitted_params)

      if @cancellation_reason.save
        flash[:info] = t("settings.cancellation_reasons.create.success")
        redirect_to settings_cancellation_reasons_path
      else
        flash.now[:alert] = @cancellation_reason.errors.full_messages.to_sentence
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @cancellation_reason = CancellationReason.find(params[:id])
    end

    def update
      @cancellation_reason = CancellationReason.find(params[:id])

      if @cancellation_reason.update(permitted_params)
        flash[:info] = t("settings.cancellation_reasons.update.success", name: @cancellation_reason.name)
        redirect_to settings_cancellation_reasons_path
      else
        flash.now[:alert] = @cancellation_reason.errors.full_messages.to_sentence
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      @cancellation_reason = CancellationReason.find(params[:id])

      if @cancellation_reason.destroy
        flash[:info] = t("settings.cancellation_reasons.destroy.success", name: @cancellation_reason.name)
      else
        flash[:alert] = @cancellation_reason.errors.full_messages.to_sentence
      end

      redirect_to settings_cancellation_reasons_path
    end

    private

    def permitted_params
      params.require(:cancellation_reason).permit(:name)
    end

    def search_term
      params.permit(:q).fetch(:q, nil)
    end
  end
end
