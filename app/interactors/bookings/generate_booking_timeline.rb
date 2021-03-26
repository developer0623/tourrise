# frozen_string_literal: true

module Bookings
  class GenerateBookingTimeline
    include Interactor

    def call
      timeline = [
        created_at_entry,
        updated_at_entry,
        offers_entries,
        invoices_entries
      ].flatten.compact

      context.timeline = timeline.sort_by(&:timestamp)
    end

    private

    def offers_entries
      context.booking.booking_offers.map do |offer|
        OpenStruct.new(
          timestamp: offer.created_at,
          highlight: true,
          message: [:offer_created]
        )
      end
    end

    def invoices_entries
      context.booking.booking_invoices.map do |invoice|
        OpenStruct.new(
          timestamp: invoice.created_at,
          highlight: true,
          message: [:invoice_created]
        )
      end
    end

    def created_at_entry
      OpenStruct.new(
        timestamp: context.booking.created_at,
        highlight: true,
        message: [:booking_created, user: context.booking.creator]
      )
    end

    def updated_at_entry
      return unless context.booking.assignee

      OpenStruct.new(
        timestamp: context.booking.updated_at,
        highlight: true,
        message: [:booking_updated, user: context.booking.assignee || nil]
      )
    end
  end
end
