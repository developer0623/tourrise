# frozen_string_literal: true

class BookingInvoicesController < ApplicationController
  decorates_assigned :booking_invoice

  def show
    @booking_invoice = BookingInvoice.find(params[:id])
  end

  def new
    @booking_invoice = initialize_booking_invoice_interactor.document

    @booking_invoice_form = Backoffice::BookingInvoiceForm.from_interactor_context(initialize_booking_invoice_interactor)
  end

  def create
    context = Documents::Create::BookingInvoice.call(booking_id: params[:booking_id], params: create_params)

    if context.success?
      flash[:notice] = [I18n.t("booking_invoices.created"), context.message]
    else
      flash[:error] = context.message
    end

    redirect_to booking_path(id: params[:booking_id])
  end

  def publish
    booking_invoice = BookingInvoice.find(params[:id])
    booking_invoice.update_attribute(:scrambled_id, ScrambledId.generate) unless booking_invoice.published?

    redirect_to request.referer
  end

  def unpublish
    booking_invoice = BookingInvoice.find(params[:id])
    booking_invoice.update_attribute(:scrambled_id, nil)

    redirect_to request.referer
  end

  private

  def initialize_booking_invoice_interactor
    @initialize_booking_invoice_interactor ||= Documents::Initialize::BookingInvoice.call(booking_id: params[:booking_id])
  end

  def create_params
    params.require(:booking_invoice).permit(
      :description,
      booking_credit: {},
      booking_resource_sku_ids: [],
      payments_attributes: %i[price due_on]
    )
  end
end
