# frozen_string_literal: true

class PaymentsCsvExportService
  include ActionView::Helpers::NumberHelper
  attr_reader :invoice

  def initialize(invoice)
    @invoice = invoice
  end

  def accounting_data
    accounting1 = {}
    accounting2 = {}

    if invoice.payments.count == 1
      bundled_snapshots = invoice.booking_resource_skus_snapshot.reject { |snapshot| snapshot["internal"] }
      bundled_snapshots += invoice.booking_resource_sku_groups_snapshot

      bundled_snapshots.each do |sku|
        accounting1 = update_hash(accounting1, cost_center(sku), financial_account(sku), amount(sku))
      end
    else
      partial_payment_snapshots.each do |sku|
        accounting1 = update_hash(accounting1, cost_center(sku), financial_account(sku), amount(sku, payment_percentage))
        accounting2 = update_hash(accounting2, cost_center(sku), financial_account(sku), remaining_amount(sku, payment_percentage))
      end

      full_payment_snapshots.each do |sku|
        accounting1 = update_hash(accounting1, cost_center(sku), financial_account(sku), amount(sku))
      end
    end

    [accounting1, accounting2]
  end

  def amount(snapshot, percentage = 1)
    snapshot["price_cents"] / 100.00 * percentage
  end

  def cost_center(snapshot)
    return I18n.t("not_entered") if snapshot["cost_center"].blank? || snapshot["cost_center"]["id"].blank?

    snapshot["cost_center"]["value"]
  end

  def customer_id
    invoice.customer_snapshot["general_customer_id"]
  end

  def customer_name
    "#{invoice.customer_snapshot['first_name']} #{invoice.customer_snapshot['last_name']}"
  end

  def financial_account(snapshot)
    return I18n.t("not_entered") if snapshot["financial_account"].blank? || snapshot["financial_account"]["id"].blank?

    financial_account_for_date(snapshot["financial_account"], invoice.booking.starts_on)
  end

  def full_payment_snapshots
    bundled_snapshots = invoice.booking_resource_skus_snapshot.select { |snapshot| !snapshot["allow_partial_payment"] && !snapshot["internal"] }
    bundled_snapshots += invoice.booking_resource_sku_groups_snapshot.reject { |snapshot| snapshot["allow_partial_payment"] }

    bundled_snapshots
  end

  def full_payment_snapshots_sum
    full_payment_snapshots.sum { |snapshot| snapshot["price_cents"] }
  end

  def partial_payment_snapshots
    bundled_snapshots = invoice.booking_resource_skus_snapshot.select { |snapshot| snapshot["allow_partial_payment"] && !snapshot["internal"] }
    bundled_snapshots += invoice.booking_resource_sku_groups_snapshot.select { |snapshot| snapshot["allow_partial_payment"] }

    bundled_snapshots
  end

  def partial_payment_snapshots_sum
    partial_payment_snapshots.sum { |snapshot| snapshot["price_cents"] }
  end

  def payment_percentage
    percentage = invoice.payments.first.price_cents.to_r / invoice.payments.sum(&:price_cents).to_r

    ((total_sum * percentage) - full_payment_snapshots_sum).to_r / partial_payment_snapshots_sum
  end

  def product_name
    Product.find(invoice.product_sku_snapshot["product_id"]).name
  end

  def remaining_amount(snapshot, percentage)
    snapshot["price_cents"] / 100.00 - amount(snapshot, percentage)
  end

  def total_sum
    full_payment_snapshots_sum + partial_payment_snapshots_sum
  end

  def update_csv(financial_account, cost_center, due_on, amount)
    [
      booking_id: invoice.booking.id,
      customer_name: customer_name,
      customer_id: customer_id,
      product: product_name,
      product_sku: invoice.product_sku_snapshot["name"],
      amount: number_with_precision(amount, precision: 2),
      booking_starts_on: I18n.l(invoice.booking_snapshot["starts_on"].to_date),
      financial_account: financial_account,
      cost_center: cost_center,
      due_on: I18n.l(due_on),
      invoice_number: invoice.decorate.number,
      invoice_date: I18n.l(invoice.created_at.to_date)
    ].first
  end

  def update_hash(hash, cost_center, financial_account, amount)
    if hash[cost_center].present? ? hash[cost_center].include?(financial_account) : false
      hash[cost_center][financial_account] += amount
    elsif hash[cost_center].present?
      hash[cost_center][financial_account] = amount
    else
      hash[cost_center] = { financial_account => amount }
    end

    hash
  end

  private

  def financial_account_for_date(financial_account, starts_on = nil)
    return unless starts_on.present?

    return financial_account["before_service_year"] if starts_on.year > invoice.created_at.year

    financial_account["during_service_year"]
  end
end
