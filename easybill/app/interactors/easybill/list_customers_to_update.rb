# frozen_string_literal: true

module Easybill
  class ListCustomersToUpdate
    include Interactor

    def call
      context.customers = ::Customer.where(
        id: only_contact_customer_ids
      ).where(
        "updated_at >= ?",
        last_synced_at
      )
    end

    private

    def only_contact_customer_ids
      ::Booking.without_drafts.pluck(:customer_id).uniq
    end

    def last_synced_at
      CustomerSync.last_sync_at.presence || DateTime.new
    end
  end
end
