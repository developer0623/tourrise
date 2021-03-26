# frozen_string_literal: true

module Api
  class BookingResourceSkusController < ApiController
    def create
      booking = Booking.find(params[:booking_id])
      resource_sku = ResourceSku.find(create_params[:resource_sku_id])

      booking_resource_sku = BookingResourceSku.new(booking: booking, resource_sku: resource_sku)

      if booking_resource_sku.save
        render json: booking_resource_sku, status: :ok
      else
        render json: { error: booking_resource_sku.errors }, status: 400
      end
    end

    private

    def create_params
      params.require(:booking_resource_sku).permit(:resource_sku_id)
    end
  end
end
