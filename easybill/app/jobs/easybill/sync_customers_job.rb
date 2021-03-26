# frozen_string_literal: true

module Easybill
  class SyncCustomersJob < EasybillJob
    around_perform :save_last_sync_at

    def perform
      customers_to_create.each do |customer|
        CreateCustomerJob.perform_later(customer.as_json(only: %i[id]))
      end

      customers_to_update.each do |customer|
        UpdateCustomerJob.perform_later(customer.as_json(only: %i[id]))
      end
    end

    private

    def customers_to_create
      ListCustomersToCreate.call.customers
    end

    def customers_to_update
      ListCustomersToUpdate.call.customers
    end

    def save_last_sync_at
      sync_started_at = DateTime.now
      yield
      CustomerSync.create(last_sync_at: sync_started_at)
    end
  end
end
