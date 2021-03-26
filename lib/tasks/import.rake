# frozen_string_literal: true

namespace :hht do
  task import_customers: :environment do
    Customers::ImportCustomersJob.perform_later
  end
end
