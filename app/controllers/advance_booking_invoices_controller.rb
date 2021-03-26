# frozen_string_literal: true

class AdvanceBookingInvoicesController < ApplicationController
  decorates_assigned :advance_booking_invoice

  def show
    @advance_booking_invoice = AdvanceBookingInvoice.find(params[:id])
  end

  def new
    @advance_booking_invoice = AdvanceBookingInvoice.new(booking_id: params[:booking_id])
  end

  def create
    context = Documents::Create::AdvanceBookingInvoice.call(booking_id: params[:booking_id], params: create_params)

    if context.success?
      flash[:notice] = [I18n.t("booking_invoices.created"), context.message]
    else
      flash[:error] = context.message
    end

    redirect_to booking_path(id: params[:booking_id])
  end

  def publish
    advance_booking_invoice = AdvanceBookingInvoice.find(params[:id])

    advance_booking_invoice.update_attribute(:scrambled_id, ScrambledId.generate) unless advance_booking_invoice.published?

    redirect_to request.referer
  end

  def unpublish
    advance_booking_invoice = AdvanceBookingInvoice.find(params[:id])

    advance_booking_invoice.update_attribute(:scrambled_id, nil)

    redirect_to request.referer
  end

  private

  def create_params
    params.require(:advance_booking_invoice).permit(
      :description,
      booking_credit: {},
      payments_attributes: %i[price due_on]
    )
  end
end
