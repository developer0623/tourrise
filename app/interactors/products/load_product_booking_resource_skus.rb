# frozen_string_literal: true

module Products
  class LoadProductBookingResourceSkus
    include Interactor

    def call
      context.product = Product.find_by_id(context.product_id)
      context.fail!(message: "product not found") unless context.product.present?

      load_bookings
      load_booking_resource_skus
    end

    private

    def load_bookings
      product_sku_ids = context.filter[:product_sku_id].presence || context.product.product_skus.pluck(:id)

      context.bookings = Booking.booked.where(product_sku_id: product_sku_ids)
    end

    def load_booking_resource_skus
      context.booking_resource_skus = BookingResourceSku.where(
        booking_id: context.bookings.pluck(:id)
      ).includes(
        :flights,
        :participants,
        resource_sku: [resource: :resource_type],
        availability: :inventory,
        booking_attribute_values: :booking_attribute,
        booking: [:customer, :season, product_sku: [:translations], product: [:translations]]
      )

      filter_by_resource_ids
    end

    def filter_by_resource_ids
      return unless context.filter[:resource_ids].present?

      resource_ids_filter = context.filter[:resource_ids].split(",")

      context.booking_resource_skus = resource_ids_filter.collect do |resource_id|
        context.booking_resource_skus.where("resource_sku_snapshot LIKE ?", "%\"resource_id\":#{resource_id}%")
      end.reduce(:or)
    end
  end
end
