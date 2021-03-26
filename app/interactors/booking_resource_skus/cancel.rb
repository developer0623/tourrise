# frozen_string_literal: true

module BookingResourceSkus
  class Cancel
    include Interactor

    delegate :cancellation_reason_id, :cancellable_type, :cancellable_id, :user_id, to: :context

    before :load_booking_resource_sku

    def call
      create_cancellation

      return if context.booking_resource_sku.booking_resource_sku_availability.blank?

      context.booking_resource_sku_availability = context.booking_resource_sku.booking_resource_sku_availability

      BookingResourceSkuAvailabilities::CancelBookingResourceSkuAvailability.call(context)
    end

    private

    def load_booking_resource_sku
      context.booking_resource_sku_id = cancellable_id

      context.booking_resource_sku || LoadBookingResourceSku.call(context)
    end

    def create_cancellation
      interactor = Cancellations::CreateForPosition.call(cancellation_params)

      if interactor.success?
        context.cancellation = interactor.cancellation
      else
        context.fail!(message: interactor.message)
      end
    end

    def cancellation_params
      {
        cancellation_reason_id: cancellation_reason_id,
        cancellable_type: cancellable_type,
        cancellable_id: cancellable_id,
        user_id: user_id
      }
    end
  end
end
