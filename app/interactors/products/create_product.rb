# frozen_string_literal: true

module Products
  class CreateProduct
    include Interactor

    before do
      context.params = context.params.with_indifferent_access
    end

    def call
      context.product = Product.new(product_params)
      assign_tags

      context.fail!(errors: context.product.errors) unless context.product.save
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
        :frontoffice_step_ids,
        :current_season_id,
        :resource_ids
      ).merge(
        product_skus_attributes: product_skus_attributes
      )
    end

    def assign_tags
      return unless context.params[:tags].present?

      tags = JSON.parse(context.params[:tags])

      context.product.tags = Tag.where(handle: tags.map { |tag| tag["code"] })
    end

    def product_skus_attributes
      context.fail!(message: "product skus missing") if context.params[:product_skus_attributes].blank?

      if context.params[:product_skus_attributes]&.keys&.count == 1
        context.params[:product_skus_attributes].tap do |product_skus_attributes|
          product_skus_attributes["0"]["name"] = context.params[:name]
        end
      else
        context.params[:product_skus_attributes]
      end
    end
  end
end
