# frozen_string_literal: true

module Api
  module V1
    class SerializableBooking < JSONAPI::Serializable::Resource
      type "bookings"

      attributes :id, :starts_on, :ends_on, :created_at, :updated_at

      attribute :status do
        @object.aasm_state
      end

      belongs_to :creator
      belongs_to :assignee
      belongs_to :product_sku
      belongs_to :customer

      has_many :participants
      has_many :booking_offers
      has_many :booking_invoices
      has_many :booking_resource_skus
      has_many :flights

      link :self do
        @url_helpers.booking_path(@object.id, locale: I18n.locale)
      end
    end
  end
end
