# frozen_string_literal: true

module Event
  RESOURCE_CREATED = "resources.created"
  RESOURCE_SKU_CREATED = "resource_skus.created"
  RESOURCE_UPDATED = "resources.updated"
  RESOURCE_SKU_UPDATED = "resource_skus.updated"
  RESOURCE_DELETED = "resources.deleted"
  RESOURCE_SKU_DELETED = "resource_skus.deleted"

  BOOKING_CANCELED = "bookings.canceled"
  BOOKING_CLOSED = "bookings.closed"
  BOOKING_COMMITTED = "bookings.committed"

  BOOKING_OFFER_CREATED = "booking_offers.created"
  BOOKING_INVOICE_CREATED = "booking_invoices.created"

  CUSTOMER_CREATED = "customers.created"
  CUSTOMER_UPDATED = "customers.updated"
end
