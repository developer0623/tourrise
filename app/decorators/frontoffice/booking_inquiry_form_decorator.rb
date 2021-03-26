# frozen_string_literal: true

module Frontoffice
  class BookingInquiryFormDecorator < BookingFormDecorator
    delegate_all

    def starts_on
      object.starts_on || configured_starts_on
    end

    def ends_on
      object.ends_on || configured_ends_on
    end

    def product_sku_name
      object.product_sku.name
    end
  end
end
