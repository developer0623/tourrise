# frozen_string_literal: true

class ReportsController < ApplicationController
  around_action :timezone_hack

  def index
    @recent_bookings = Booking.where(created_at: 1.week.ago..Date.today)
    @bookings = Booking.all

    @customers_comparison = { returning: Customer.returning.count, new: Customer.happy_new.count }
    @popular_product_skus = ProductSku.joins(:bookings).group(:name).count.sort_by { |_, bookings_count| bookings_count }.reverse.first(5)
  end

  private

  def timezone_hack
    Booking.default_timezone = :utc

    yield

    Booking.default_timezone = :local
  end
end
