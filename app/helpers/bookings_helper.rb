# frozen_string_literal: true

module BookingsHelper
  def new_booking_with_customer_path(customer)
    new_booking_path(customer_id: customer.id, step: :select_product_variant_step)
  end
end
