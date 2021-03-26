# frozen_string_literal: true

module Frontoffice
  class BookingsController < FrontofficeController
    before_action :redirect_to_summary_action

    decorates_assigned :booking_form

    def new
      context = InitializeBookingForm.call(
        product_sku_handle: params[:product_sku_handle],
        session: session
      )

      if context.success?
        @booking_form = context.booking_form
      else
        render_not_found
      end
    end

    def create
      context = CreateBookingForm.call(product_sku_handle: params[:product_sku_handle], params: booking_params.to_h, session: session)

      @booking_form = context.booking_form

      if context.success?
        session[:latest_step] = params[:step]
        redirect_to @booking_form.decorate.next_step_path
      else
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      context = LoadBookingForm.call(
        scrambled_id: params[:scrambled_id],
        step_handle: params[:step],
        session: session
      )

      @booking_form = context.booking_form

      if context.success?
        render "edit", status: 200
      else
        handle_error(context)
      end
    end

    def update
      context = UpdateBookingForm.call(
        scrambled_id: params[:scrambled_id],
        step_handle: params[:step],
        params: booking_params.to_h,
        session: session
      )

      @booking_form = context.booking_form

      if context.success?
        redirect_to @booking_form.decorate.next_step_path
      else
        render "edit", status: :unprocessable_entity
      end
    end

    def summary
      context = LoadBookingForm.call(scrambled_id: params[:scrambled_id], step_handle: "summary", session: session)

      if context.success?
        @booking_form = context.booking_form
      else
        handle_error(context)
      end
    end

    def submit
      context = SubmitBooking.call(scrambled_id: params[:scrambled_id], params: submit_params, session: session)

      if context.success?
        render "success", status: 200
      else
        handle_error(context)
      end
    end

    def destroy
      product_sku_handle = @booking.product_sku.handle

      @booking.destroy

      redirect_to new_frontoffice_product_booking_path(product_sku_handle)
    end

    private

    def submit_params
      params.require(:booking).permit(
        :terms_of_service_accepted,
        :privacy_policy_accepted,
        :wishyouwhat,
        customer_attributes: %i[id newsletter]
      ).to_h
    end

    def booking_params
      params.require(:booking).permit(
        :creator_id,
        :starts_on,
        :ends_on,
        :adults,
        :kids,
        :babies,
        :rooms_count,
        :flights_count,
        :rentalbikes_count,
        :rentalcars_count,
        :wishyouwhat,
        customer_attributes: %i[
          title
          first_name
          last_name
          birthdate
          gender
          address_line_1 address_line_2
          primary_phone secondary_phone
          locale
          zip
          city
          state
          country
          email
          company_name
        ],
        booking_resource_skus_attributes: %i[id quantity resource_sku_id _destroy],
        booking_room_assignments_attributes: %i[id adults kids babies _destroy],
        booking_flight_requests_attributes: %i[id starts_on ends_on departure_airport destination_airport _destroy],
        booking_rentalbike_requests_attributes: %i[id starts_on ends_on height],
        booking_rentalcar_requests_attributes: %i[id starts_on ends_on rentalcar_class _destroy],
        participants_attributes: %i[id first_name last_name email birthdate participant_type_id placeholder]
      )
    end

    def redirect_to_summary_action
      return unless params[:step] == "summary"

      redirect_to summary_frontoffice_booking_path(params[:scrambled_id])
    end

    def handle_error(context)
      flash.now[:error] = context.message

      case context.code
      when :not_found
        render_not_found
      when :submitted
        render "success"
      else
        @booking_form = context.booking_form
        redirect_back(fallback_location: edit_frontoffice_booking_path(params[:scrambled_id], step: params[:step]))
      end
    end
  end
end
