# frozen_string_literal: true

class BookingResourceSkusController < ApplicationController
  before_action :load_current_step, only: :new
  before_action :load_booking, only: %i[show new create edit update]
  before_action :load_booking_resource_sku, only: %i[show edit update]

  decorates_assigned :booking_resource_sku
  decorates_assigned :booking

  def show; end

  def new
    case @current_step
    when :select_booking_resource_sku_step
      context = Bookings::ListResourceSkus.call(
        filter: filter_params.with_indifferent_access,
        sort: sort_params,
        page: params[:page]
      )

      @resource_skus = context.resource_skus.decorate
    end
  end

  def create
    context = BookingResourceSkus::CreateBookingResourceSku.call(
      booking_id: params[:booking_id],
      resource_sku_id: params[:resource_sku_id],
      params: params.permit!.to_h.with_indifferent_access,
      user_id: current_user.id
    )

    if context.success?
      flash[:success] = [I18n.t("booking_resource_skus.create.success", name: context.resource_sku.name), context.message]
      redirect_to booking_path(params[:booking_id], anchor: "BookingResourceSkus")
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  def edit
    @booking_resource_sku.build_booking_resource_sku_availability unless @booking_resource_sku.booking_resource_sku_availability.present?
  end

  def update
    context = BookingResourceSkus::UpdateBookingResourceSku.call(
      booking_id: params[:booking_id],
      booking_resource_sku_id: params[:id],
      params: booking_resource_sku_params,
      user_id: current_user.id
    )

    if context.success?
      flash[:success] = [I18n.t("booking_resource_skus.update.success"), context.message]
      redirect_to booking_path(@booking.id, anchor: "BookingResourceSkus")
    else
      @booking_resource_sku = context.booking_resource_sku
      flash[:error] = context.message
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    context = BookingResourceSkus::DeleteBookingResourceSku.call(
      booking_id: params[:booking_id],
      booking_resource_sku_id: params[:id]
    )

    if context.success?
      flash[:success] = [I18n.t("booking_resource_skus.destroy.success"), context.message]
      redirect_to request.referer, info: "deleted"
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  def duplicate
    context = BookingResourceSkus::DuplicateBookingResourceSku.call(
      booking_id: params[:booking_id],
      booking_resource_sku_id: params[:id]
    )

    if context.success?
      flash[:success] = I18n.t("booking_resource_skus.duplicate.success")
      redirect_to edit_booking_booking_resource_sku_path(context.booking, context.new_booking_resource_sku)
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  def block
    context = BookingResourceSkus::BlockBookingResourceSku.call(
      user_id: current_user.id,
      booking_resource_sku_id: params[:id]
    )

    if context.success?
      flash[:success] = I18n.t("booking_resource_skus.block.success")
      redirect_to booking_path(params[:booking_id])
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  def unblock
    context = BookingResourceSkus::UnblockBookingResourceSku.call(
      booking_resource_sku_id: params[:id]
    )

    if context.success?
      flash[:success] = I18n.t("booking_resource_skus.unblock.success")
      redirect_to booking_path(params[:booking_id])
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  private

  def load_booking
    @booking = Booking.find(params[:booking_id])
  end

  def load_booking_resource_sku
    @booking_resource_sku = BookingResourceSku.find(params[:id])
  end

  def booking_resource_sku_params
    params.require(:booking_resource_sku).permit(
      :resource_sku_id,
      :price,
      :quantity,
      :allow_partial_payment,
      :internal,
      :cost_center_id,
      :financial_account_id,
      :remarks,
      participant_ids: [],
      booking_resource_sku_availability_attributes: %i[id availability_id],
      flights_attributes: %i[id airline_code flight_number departure_at departure_airport arrival_at arrival_airport _destroy],
      booking_attribute_values_attributes: %i[id booking_attribute_id attribute_type name handle value]
    ).to_h
  end

  def filter_params
    params.permit!.to_h.slice(
      "q",
      "resource_type_id",
      "product_id"
    )
  end

  def load_current_step
    if params[:step].blank?
      @current_step = :select_resource_type_step
    else
      @current_step ||= params[:step].to_sym
    end
  end
end
