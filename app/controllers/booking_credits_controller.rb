# frozen_string_literal: true

class BookingCreditsController < ApplicationController
  decorates_assigned :booking_credits

  def new
    @booking_credit = BookingCredit.new(booking_id: params[:booking_id])
  end

  def create
    context = BookingCredits::CreateBookingCredit.call(booking_id: params[:booking_id], params: create_params)

    if context.success?
      flash[:notice] = I18n.t("booking_credits.create.success")
    else
      flash[:error] = context.message
    end

    redirect_to booking_path(id: params[:booking_id])
  end

  def edit
    @booking_credit = BookingCredit.find(params[:id])
  end

  def update
    context = BookingCredits::UpdateBookingCredit.call(booking_credit_id: params[:id], params: update_params)

    if context.success?
      flash[:notice] = I18n.t("booking_credits.update.success")
    else
      flash[:error] = context.message
    end

    redirect_to booking_path(id: params[:booking_id])
  end

  def destroy
    context = BookingCredits::DeleteBookingCredit.call(booking_credit_id: params[:id])

    if context.success?
      flash[:notice] = I18n.t("booking_credits.destroy.success")
    else
      flash[:error] = context.message
    end

    redirect_to booking_path(id: params[:booking_id])
  end

  private

  def create_params
    params.require(:booking_credit).permit(
      :name,
      :price,
      :financial_account_id,
      :cost_center_id
    )
  end

  def update_params
    params.require(:booking_credit).permit(
      :name,
      :price,
      :financial_account_id,
      :cost_center_id
    )
  end
end
