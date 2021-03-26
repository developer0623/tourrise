# frozen_string_literal: true

class ProductBookingResourceSkusDecorator < PaginatingDecorator
  def filter_options(product:)
    [
      product_skus_filter(product),
      resource_skus_filter(product)
    ]
  end

  def product_skus_filter(product)
    {
      name: "product_sku_id",
      options: product.product_skus.pluck(:id, :name)
    }
  end

  def resource_skus_filter(product)
    product_sku_ids = product.product_skus.pluck(:id)
    resource_ids = Booking.where(product_sku_id: product_sku_ids).joins(booking_resource_skus: [resource_sku: :resource]).select("resources.id").distinct

    options = Resource.where(id: resource_ids).pluck(:id, :name)

    {
      name: "resource_ids",
      multiselect: true,
      options: options
    }
  end
end
