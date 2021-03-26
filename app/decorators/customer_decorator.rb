# frozen_string_literal: true

class CustomerDecorator < Draper::Decorator
  delegate_all
  decorates_association :bookings
  decorates_association :custom_attribute_values

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def attributes
    [
      [:company_name, company_name],
      [:title, title],
      [:first_name, first_name],
      [:last_name, last_name],
      [:gender, gender],
      [:birthdate, birthdate],
      [:country, country],
      [:state, state],
      [:zip, zip],
      [:address_line_1, address_line_1],
      [:address_line_2, address_line_2],
      [:city, city],
      [:locale, locale],
      [:email_link, email_link],
      [:primary_phone, primary_phone],
      [:secondary_phone, secondary_phone],
      [:newsletter, h.t(newsletter)],
      [:created_at, created_at],
      [:updated_at, updated_at]
    ]
  end

  def created_at
    h.l(customer.created_at.to_date)
  end

  def updated_at
    h.l(customer.updated_at.to_date)
  end

  def url
    customer.persisted? ? h.customer_path(customer) : nil
  end

  def email_link
    customer.email ? (h.mail_to customer.email) : h.empty_state(h.t("not_entered"))
  end

  def phone
    if primary_phone || secondary_phone
      str = "".html_safe
      str << h.link_to(primary_phone, "tel:#{primary_phone}") if primary_phone
      str << "<br>".html_safe if primary_phone && secondary_phone
      str << h.link_to(secondary_phone, "tel:#{secondary_phone}") if secondary_phone
    else
      h.empty_state(h.t("not_entered"))
    end
  end

  def name
    if first_name || last_name
      url ? (h.link_to full_name, url) : full_name
    else
      h.empty_state(h.t("not_entered"))
    end
  end

  def full_name
    h.display_name(first_name: first_name, last_name: last_name)
  end

  def address
    if address_line_1 || address_line_2 || zip || city || country
      str = "".html_safe
      str << address_line_1
      str << "<br>".html_safe
      str << "#{address_line_2}<br>".html_safe if address_line_2.present?
      str << "#{zip} #{city}"
      str << "<br>".html_safe
      str << country
    else
      h.empty_state(h.t("not_entered"))
    end
  end

  def birthdate_iso8601
    return unless customer.birthdate

    customer.birthdate.iso8601
  end

  def bookings_count
    h.t("customers.index.bookings_count", count: customer.bookings.count + customer.participate_bookings.count)
  end

  def bookings_total_price
    h.humanized_money_with_symbol(customer.bookings.booked.sum(&:total_price))
  end

  def gender
    return unless object.gender.present?

    h.t("genders.#{customer.gender}")
  end

  def country
    country = ISO3166::Country[customer.country]
    return unless country.present?

    country.translations[I18n.locale.to_s]
  end

  def localized_birthdate
    return unless object.birthdate.present?

    h.l(object.birthdate, format: :default)
  end

  def locale
    return unless object.locale.present?

    h.t(customer.locale.to_s)
  end
end
