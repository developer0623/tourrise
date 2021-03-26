# frozen_string_literal: true

module Products
  class UpdateProduct
    include Interactor

    before do
      context.params = context.params.with_indifferent_access
    end

    def call
      context.product.assign_attributes(product_params)
      assign_tags

      context.fail!(message: context.product.errors) unless context.product.save
    end

    private

    def product_params
      terms_of_service = PUBLIC_LOCALES.map { |locale| "terms_of_service_#{locale}" }

      context.params.with_indifferent_access.slice(
        :name,
        :description,
        *terms_of_service,
        :financial_account_id,
        :cost_center_id,
        :resource_ids,
        :frontoffice_step_ids,
        :current_season_id,
        :product_skus_attributes
      )
    end

    def assign_tags
      return unless context.params.key?(:tags)

      tags = context.params[:tags].presence ? JSON.parse(context.params[:tags]) : []

      context.product.tags = Tag.where(handle: tags.map { |tag| tag["code"] })
    end
  end
end
