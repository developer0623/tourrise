# frozen_string_literal: true

module Frontoffice
  class BookingInquiryForm
    include ActiveModel::Model
    include Draper::Decoratable
    extend ActiveModel::Translation

    REQUEST_FIELDS = %w[
      creator_id
      product_sku_id
      starts_on
      ends_on
      adults
      kids
      babies
      first_name
      last_name
      wishyouwhat
      email
    ].freeze

    attr_accessor(*REQUEST_FIELDS)
    attr_writer :booking

    validates :starts_on,
              :ends_on,
              :adults,
              :product_sku_id,
              :first_name,
              :last_name,
              :email,
              :creator_id, presence: true

    validates :adults, numericality: { greater_than: 0 }
    validates :kids, :babies, numericality: { greater_than_or_equal_to: 0 }
    validates_with EndsOnAfterStartsOnValidator

    delegate :product, to: :product_sku

    def save
      valid? && booking.save
    end

    def product_sku
      @product_sku ||= ProductSku.find(product_sku_id)
    end
  end
end
