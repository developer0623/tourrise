# frozen_string_literal: true

class ProductSkuDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{object.product.name} - #{object.name}"
  end

  def edit_link
    h.edit_product_product_sku_path(object.product, object)
  end

  def delete_link
    h.product_product_sku_path(object.product, object)
  end

  def frontoffice_link
    h.new_frontoffice_product_booking_path(object.handle)
  end

  def bookings_count
    object.bookings.without_drafts.count
  end

  def bookings_link
    h.bookings_path(product_id: object.product_id, product_sku_id: object.id)
  end

  def accounting_information
    financial_account_name = financial_account&.display_name
    cost_center_name = cost_center&.display_name

    [financial_account_name, cost_center_name].compact.join(" / ")
  end

  def display_bookings_count
    text = h.t(".bookings_link", count: bookings_count)

    bookings_count.positive? ? h.link_to(text, bookings_link) : text
  end

  def starts_on
    return "n.a." unless object.product_sku_booking_configuration.present?
    return "n.a." unless object.product_sku_booking_configuration.starts_on.present?

    h.l(object.product_sku_booking_configuration.starts_on, format: :default)
  end

  def ends_on
    return "n.a." unless object.product_sku_booking_configuration.present?
    return "n.a." unless object.product_sku_booking_configuration.ends_on.present?

    h.l(object.product_sku_booking_configuration.ends_on, format: :default)
  end

  def max_bookings
    return "unendl." unless object.product_sku_booking_configuration.present?
    return "unendl." unless object.product_sku_booking_configuration.max_bookings.present?

    object.product_sku_booking_configuration.max_bookings
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
