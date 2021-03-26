# frozen_string_literal: true

module Products
  class UpdateSku
    include Interactor

    def call
      load_sku

      context.fail!(message: "Invalid sku params: #{context.sku.errors}") unless context.sku.update(base_params)

      context.sku.reload
    end

    private

    def base_params
      base_params = context.params.slice(:name, :stock)

      base_params[:sku_pricing_attributes] = context.params.slice(:price) if context.params[:price].present?

      base_params
    end

    def load_sku
      load_sku_context = LoadSku.call(
        product_id: context.product_id,
        sku_id: context.sku_id
      )

      context.fail!(message: load_sku_context.message) unless load_sku_context.success?

      context.sku = load_sku_context.sku
    end
  end
end
