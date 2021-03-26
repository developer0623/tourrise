# frozen_string_literal: true

class BookingEventsController < ApplicationController
  before_action :load_booking
  before_action :index_breadcrumb, only: :index

  def index
    @events = Bookings::ListBookingEvents.call(booking: @booking,
                                               page: params[:page],
                                               filter: filter_params,
                                               sort: sort_params).events
    @events = BookingEventDecorator.decorate_collection(@events)
  end

  private

  def load_booking
    @booking = Booking.find(params[:booking_id])
  end

  def filter_params
    {
      event: params[:event],
      item_type: params[:item_type]
    }
  end

  def index_breadcrumb
    @breadcrumb = [{
      url: root_path, label: I18n.t("navigation.home")
    }, {
      url: bookings_path, label: I18n.t("navigation.bookings")
    }, {
      url: booking_path(params[:booking_id]), label: I18n.t("navigation.booking", id: params[:booking_id])
    }, {
      label: I18n.t("navigation.booking_events")
    }]
  end
end
