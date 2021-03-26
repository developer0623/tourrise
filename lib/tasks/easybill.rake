# frozen_string_literal: true

namespace :easybill do
  task sync_customers: :environment do
    Easybill::SyncCustomersJob.perform_later
  end

  task listen: :environment do
    Easybill::Amqp::Listener.new(
      [
        ["booking_offers.created", "createEasybillOffer", Easybill::BookingOfferCreatedHandler],
        ["booking_invoices.created", "createEasybillInvoice", Easybill::BookingInvoiceCreatedHandler],
        ["customers.created", "createEasybillCustomer", Easybill::CustomerCreatedHandler],
        ["customers.updated", "updateEasybillCustomer", Easybill::CustomerUpdatedHandler],
        ["bookings.canceled", "cancelEasybillInvoices", Easybill::BookingCanceledHandler],
        ["resource_skus.created", "createEasybillPosition", Easybill::ResourceSkuCreatedHandler],
        ["resource_skus.updated", "updateEasybillPosition", Easybill::ResourceSkuUpdatedHandler]
      ]
    ).start
  end
end
