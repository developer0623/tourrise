# frozen_string_literal: true

class BookingEventsDecorator < PaginatingDecorator
  def event_filter
    %w[create update destroy].map do |event_type|
      [event_type, I18n.t("booking_events.event_type.#{event_type}")]
    end
  end

  def item_type_filter
    %w[Booking BookingOffer BookingInvoice Customer Participant BookingResourceSku BookingResourceSkuGroup].map do |item_type|
      [item_type, I18n.t("activerecord.models.#{item_type.underscore}.one")]
    end
  end
end
