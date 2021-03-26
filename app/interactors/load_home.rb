# frozen_string_literal: true

class LoadHome
  include Interactor

  def call
    context.bookings = Booking.without_drafts.includes(:customer, :assignee, :product_sku, :product).unassigned
  end
end
