# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class BookingDecorator < Draper::Decorator
  delegate_all

  decorates_association :resources
  decorates_association :assignee
  decorates_association :customer
  decorates_association :participants, with: ParticipantDecorator
  decorates_association :booking_rentalbike_requests
  decorates_association :booking_rentalcar_requests
  decorates_association :booking_flight_requests
  decorates_association :booking_resource_skus
  decorates_association :booking_resource_sku_groups
  decorates_association :booking_offers
  decorates_association :booking_invoices

  def self.collection_decorator_class
    BookingsDecorator
  end

  def to_json(*_args)
    BookingSerializer.new(self).to_json
  end

  def participants_count
    participants.count
  end

  def available_seasons
    product_sku.seasons
  end

  def display_due_on
    h.l(object.due_on)
  end

  def product_name
    "#{object.product_sku.product&.name} - #{object.product_sku.name}"
  end

  def product_sku_handle
    object.product_sku.handle
  end

  def entry
    h.l(created_at, format: :long)
  end

  def timeline
    Bookings::GenerateBookingTimeline.call(booking: booking).timeline.map do |timeline_entry|
      TimelineEntryDecorator.new(timeline_entry)
    end
  end

  def status
    if booking.assignee.present?
      h.t("bookings.states.in_progress")
    else
      h.t("bookings.states.initial")
    end
  end

  def secondary_state
    return unless object.secondary_state.present?

    h.t("bookings.secondary_state.#{object.secondary_state}")
  end

  def assignee
    return unless booking.assignee

    h.display_name(first_name: booking.assignee.first_name, last_name: booking.assignee.last_name)
  end

  def creator
    h.display_name(first_name: booking.creator.first_name, last_name: booking.creator.last_name)
  end

  def start_date
    if starts_on.present?
      l(booking.starts_on, format: :long)
    else
      h.empty_state(h.t("not_entered"))
    end
  end

  def end_date
    if ends_on.present?
      l(booking.ends_on, format: :long)
    else
      h.empty_state(h.t("not_entered"))
    end
  end

  def overdue?
    return false if object.due_on.blank?
    return false if object.booked? || object.closed? || object.canceled?

    due_on.past?
  end

  def user_can_edit_due_on?
    object.requested? || object.in_progress?
  end

  def resource_groups
    booking_resource_skus.group_by(&:resource_snapshot)
  end

  def total_price
    h.humanized_money_with_symbol(object.total_price)
  end

  def credits_subtracted_total_price
    h.humanized_money_with_symbol(object.total_price - booking_credits.sum(&:price))
  end

  def total_invoiced_amount
    return unless booking_invoices.any?

    h.humanized_money_with_symbol(booking_invoices.sum(&:total_price))
  end

  def customer?
    booking.customer.present?
  end

  def cloneable?
    object.requested? || object.in_progress?
  end

  def editable_by_user?
    user_can_create_offer? || user_can_create_offer? || user_can_commit_booking? || user_can_cancel_booking? || user_can_close_booking?
  end

  def user_can_clone_booking?
    object.assignee.present?
  end

  def user_can_create_offer?
    true
  end

  def user_can_create_invoice?
    true
  end

  def user_can_commit_booking?
    true
  end

  def committable?
    booking_service.committable?
  end

  def cancelable?
    booking.may_cancel?
  end

  def closeable?
    booking.may_close?
  end

  def user_can_cancel_booking?
    true
  end

  def user_can_close_booking?
    true
  end

  def editable?
    %w[booked canceled closed].exclude? object.aasm_state
  end

  def user_can_edit_booking?
    editable?
  end

  def documents
    (booking_offers + booking_invoices).sort_by(&:created_at).reverse!
  end

  def offer_is_creatable?
    booking_service.offer_creatable?
  end

  def invoice_is_creatable?
    booking_service.invoice_creatable?
  end

  def offer_available?
    booking_service.offer_available?
  end

  def invoice_available?
    booking_service.invoice_available?
  end

  def groupable_positions_available?
    object.booking_resource_skus.groupable.any?
  end

  def date_range
    "#{start_date} - #{end_date}"
  end

  private

  def booking_service
    @booking_service ||= BookingService.new(object)
  end
end
# rubocop:enable Metrics/ClassLength
