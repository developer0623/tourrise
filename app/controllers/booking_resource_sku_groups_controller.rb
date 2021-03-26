# frozen_string_literal: true

class BookingResourceSkuGroupsController < ApplicationController
  before_action :load_booking, only: %i[new edit create calculate]

  decorates_assigned :booking_resource_sku_group

  def new
    @booking_resource_sku_group = @booking.booking_resource_sku_groups.new
  end

  def create
    context = BookingResourceSkuGroups::CreateBookingResourceSkuGroup.call(params: create_params, booking: @booking)

    if context.success?
      flash[:notice] = [I18n.t("booking_resource_sku_groups.create.success"), context.message]
      redirect_to booking_path(context.booking)
    else
      flash.now[:error] = context.message
      @booking_resource_sku_group = context.booking_resource_sku_group
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @booking_resource_sku_group = @booking.booking_resource_sku_groups.find(params[:id])
  end

  def update
    context = BookingResourceSkuGroups::UpdateBookingResourceSkuGroup.call(booking_resource_sku_group_id: params[:id], params: update_params)

    if context.success?
      flash[:notice] = [I18n.t("booking_resource_sku_groups.update.success"), context.message]
      redirect_to booking_path(context.booking, anchor: "BookingResourceSkuGroup-#{params[:id]}")
    else
      @booking_resource_sku_group = context.booking_resource_sku_group
      flash[:error] = context.message
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    context = BookingResourceSkuGroups::DeleteBookingResourceSkuGroup.call(booking_resource_sku_group_id: params[:id])

    if context.success?
      flash[:notice] = [I18n.t("booking_resource_sku_groups.destroy.success"), context.message]
    else
      flash[:error] = I18n.t("booking_resource_sku_groups.destroy.error")
    end

    redirect_to booking_path(context.booking, anchor: "ResourcesSection")
  end

  private

  def load_booking
    @booking = Booking.find(params[:booking_id])
  end

  def create_params
    params.require(:booking_resource_sku_group).permit(
      :name,
      :price,
      :financial_account_id,
      :cost_center_id,
      :allow_partial_payment,
      booking_resource_sku_ids: []
    ).to_h
  end

  def update_params
    params.require(:booking_resource_sku_group).permit(:name, :price, :financial_account_id, :cost_center_id, :allow_partial_payment)
  end
end
