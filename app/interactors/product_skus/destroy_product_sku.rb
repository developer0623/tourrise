# frozen_string_literal: true

module ProductSkus
  class DestroyProductSku
    include Interactor

    def call
      Products::LoadProduct.call!(context)
      LoadProductSku.call!(context)

      context.fail!(message: I18n.t("product_skus.destroy_product_sku.errors.has_active_bookings", name: context.product_sku.name)) if context.product_sku.bookings.without_drafts.any?

      context.fail!(message: context.product_sku.errors.full_messages) unless context.product_sku.destroy
    end
  end
end
