# frozen_string_literal: true

class SerializableCustomer < JSONAPI::Serializable::Resource
  type "customers"

  attributes :id,
             :title,
             :first_name,
             :last_name,
             :gender,
             :country,
             :state,
             :zip,
             :address_line_1,
             :address_line_2,
             :city,
             :locale,
             :email,
             :birthdate,
             :primary_phone,
             :secondary_phone,
             :participant_type,
             :created_at,
             :updated_at

  attribute :full_name do
    "#{@object.first_name} #{@object.last_name}"
  end

  attribute :full_address do
    "#{@object.address_line_1} #{@object.address_line_2}"
  end

  attribute :localized_birthdate do
    next "" unless @object.birthdate.present?

    I18n.l(@object.birthdate, format: :long)
  end

  attribute :bookings_count do
    I18n.t("customers.index.bookings_count", count: @object.bookings.count)
  end

  link :self do
    @url_helpers.customer_path(@object.id, locale: I18n.locale)
  end
end
