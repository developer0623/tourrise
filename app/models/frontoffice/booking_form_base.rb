# frozen_string_literal: true

module Frontoffice
  class BookingFormBase
    include ActiveModel::Model
    extend ActiveModel::Translation
    extend ActiveModel::Callbacks
    include Decoratable

    define_model_callbacks :save

    attr_accessor :booking

    delegate :product_sku, to: :booking
    delegate :product, to: :product_sku

    def self.initialize_from_booking(booking)
      form = new(booking: booking)
      form.assign_attributes(booking.attributes.slice(*self::FORM_FIELDS))
      form
    end

    def save
      self.class::FORM_FIELDS.each do |form_field|
        booking.assign_attributes("#{form_field}": public_send(form_field))
      end

      run_callbacks :save do
        return unless valid?

        booking.save
      end
    end
  end
end
