# frozen_string_literal: true

module Seasons
  class UpdateSeason
    include Interactor

    before do
      LoadSeason.call(context)
    end

    def call
      season_params.fetch("seasonal_product_skus_attributes", {}).each do |_, attribute|
        next unless attribute["enabled"].to_i.zero?

        attribute["_destroy"] = true
      end
      context.fail!(message: context.season.errors.full_messages) unless context.season.update(season_params)
    end

    private

    def season_params
      context.params.slice(
        "name",
        "published_at",
        "seasonal_product_skus_attributes"
      )
    end
  end
end
