# frozen_string_literal: true

class CancellationsController < ApplicationController
  def create
    context = Cancellations::Create.call(cancellation_interactor_params)

    if context.success?
      flash[:success] = I18n.t("cancellations.created")
      redirect_to request.referer, info: "cancelled"
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  private

  def cancellation_interactor_params
    permitted_cancellation_params.merge(user_id: current_user.id)
  end

  def permitted_cancellation_params
    params.require(:cancellation).permit(
      :cancellation_reason_id,
      :cancellable_type,
      :cancellable_id
    )
  end
end
