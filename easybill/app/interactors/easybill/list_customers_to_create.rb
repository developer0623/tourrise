# frozen_string_literal: true

module Easybill
  class ListCustomersToCreate
    include Interactor

    def call
      context.customers = ::Customer.where(
        id: only_contact_customer_ids
      ).where.not(
        id: synced_easybill_customer_ids
      )
    end

    private

    def only_contact_customer_ids
      ::Booking.without_drafts.pluck(:customer_id).uniq
    end

    def synced_easybill_customer_ids
      ::Easybill::Customer.pluck(:customer_id).uniq
    end
  end
end
