# frozen_string_literal: true

module Api
  module V1
    class SerializableProductSku < JSONAPI::Serializable::Resource
      type "product_skus"

      attributes :id, :name

      attribute :product_name do
        @object.product.name
      end

      link :self do
        @url_helpers.product_product_sku_path(@object.product_id, @object.id, locale: I18n.locale)
      end
    end
  end
end
