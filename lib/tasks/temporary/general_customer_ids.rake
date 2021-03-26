# frozen_string_literal: true

namespace :customers do
  desc "Add general customer ids to customers"

  task add_general_customer_ids_to_customers: :environment do
    puts "task started"

    Customer.all.each do |customer|
      customer.update(general_customer_id: customer.id + 10_000) if customer.general_customer_id.blank?
    end

    puts "general_customer_ids added to customers"
  end
end
