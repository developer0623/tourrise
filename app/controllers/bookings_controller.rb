# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class BookingsController < ApplicationController
  before_action :load_current_step, only: :new
  before_action :load_booking, only: %i[show edit]
  before_action :load_customer, only: %i[new create]

  def index
    @bookings = Bookings::ListBookings.call(
      page: params[:page],
      filter: filter_params,
      sort: sort_params
    ).bookings.decorate
  end

  def new
    case @current_step
    when :select_customer_step
      @customers = Customers::ListCustomers.call.customers.decorate
    when :select_product_variant_step
      @product_skus = ProductSkus::ListProductSkus.call.product_skus.decorate
    when :request_data_step
      @product_sku = ProductSkus::LoadProductSku.call(product_sku_id: params[:product_sku_id]).product_sku.decorate
      @season = Season.find_by(id: params[:season_id]) || @product_sku.current_season
    end

    @booking = Booking.new(creator: current_user)
  end

  def create
    context = Bookings::CreateBooking.call(params: create_booking_params, current_user: current_user)

    if context.success?
      flash[:success] = t(".success")
      redirect_to booking_path(context.booking)
    else
      @booking = context.booking
      flash[:error] = @booking.errors.full_messages
      render "new", status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    context = Bookings::UpdateBooking.call(booking_id: params[:id], params: booking_params)

    if context.success?
      redirect_to redirect_path_after_update(context.booking), notice: t("bookings.status_changes.updated")
    else
      flash[:error] = context.message
      @booking = context.booking.decorate
      render "edit", status: :unprocessable_entity
    end
  end

  def commit
    context = Bookings::CommitBooking.call(booking_id: params[:id], user_id: current_user.id)

    if context.success?
      redirect_to_booking flash: { success: t("bookings.status_changes.committed") }
    else
      flash[:error] = context.message
      redirect_to_booking
    end
  end

  def cancel
    context = Bookings::CancelBooking.call(booking_id: params[:id], user_id: current_user.id)

    if context.success?
      redirect_to_booking notice: t("bookings.status_changes.canceled")
    else
      redirect_to_booking alert: context.message
    end
  end

  def close
    context = Bookings::CloseBooking.call(booking_id: params[:id], user_id: current_user.id)

    if context.success?
      redirect_to_booking notice: t("bookings.status_changes.closed")
    else
      redirect_to_booking alert: context.message
    end
  end

  def reopen
    context = Bookings::ReopenBooking.call(booking_id: params[:id], user_id: current_user.id)

    if context.success?
      redirect_to_booking notice: t("bookings.status_changes.reopened")
    else
      redirect_to_booking alert: context.message
    end
  end

  def assign_employee
    context = Bookings::ChangeAssignee.call(booking_id: params[:id], user_id: current_user.id)

    if context.success?
      redirect_to_booking notice: t("bookings.status_changes.assigned")
    else
      redirect_to_booking alert: context.message
    end
  end

  def unassign_employee
    context = Bookings::UnassignAssignee.call(booking_id: params[:id])

    if context.success?
      redirect_to_booking notice: t("bookings.status_changes.unassigned")
    else
      redirect_to_booking alert: context.message
    end
  end

  def duplicate
    context = Bookings::DuplicateBooking.call(original_booking_id: params[:id], creator: current_user)

    if context.success?
      flash[:notice] = t("bookings.duplicate.success")
      redirect_to edit_booking_path(context.booking)
    else
      load_booking
      flash[:error] = context.message
      render "show", status: :unprocessable_entity
    end
  end

  private

  def load_booking
    context = Bookings::LoadBooking.call(booking_id: params[:id])
    render_not_found && return unless context.success?

    booking = context.booking
    @booking = booking.decorate
  end

  def booking_params
    params.require(:booking).permit(
      :customer_id,
      :starts_on,
      :ends_on,
      :due_on,
      :season_id,
      :secondary_state,
      :product_sku_id,
      :assignee_id,
      :title,
      tag_ids: [],
      participants_attributes: {}
    ).to_h
  end

  def create_booking_params
    params.require(:booking).permit(
      :customer_id,
      :product_sku_id,
      :starts_on,
      :season_id,
      :ends_on,
      :adults,
      :kids,
      :babies,
      :wishyouwhat
    )
  end

  def filter_params
    {
      status: params[:status],
      secondary_state: params[:secondary_state],
      product_id: params[:product_id],
      product_sku_id: params[:product_sku_id],
      season_id: params[:season_id],
      assignee_id: params[:assignee_id]
    }
  end

  def redirect_to_booking(args = {})
    redirect_to booking_path(id: params[:id]), args
  end

  def load_current_step
    if params[:step].blank?
      @current_step = :select_customer_step
    else
      @current_step ||= params[:step].to_sym
    end
  end

  def load_customer
    return unless params[:customer_id].present?

    @customer = Customer.find_by_id(params[:customer_id]).decorate
  end

  def redirect_path_after_update(booking)
    return booking_path(booking) unless params&.dig(:booking, :redirect_path).present?

    params[:booking][:redirect_path]
  end
end
# rubocop:enable Metrics/ClassLength
