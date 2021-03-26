# frozen_string_literal: true

module Seasons
  class CreateSeason
    include Interactor

    before do
      Products::LoadProduct.call!(context)
    end

    def call
      season_params.fetch("seasonal_product_skus_attributes", {}).each do |_, attribute|
        next unless attribute["enabled"].to_i.zero?

        attribute["_destroy"] = true
      end

      context.season = Season.new(season_params)

      context.fail!(message: context.season.errors.full_messages) unless context.season.save
    end

    private

    def season_params
      context.params.slice(
        "name",
        "published_at",
        "seasonal_product_skus_attributes"
      ).merge("product" => context.product)
    end
  end
end
