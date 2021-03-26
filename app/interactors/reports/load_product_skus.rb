# frozen_string_literal: true

module Reports
  class LoadProductSkus
    include Interactor

    delegate :filter, to: :context

    before do
      context.season_ids = load_season_ids
    end

    def call
      context.product_skus = ProductSku.includes(:seasons)

      apply_filters
    end

    private

    def apply_filters
      context.product_skus = context.product_skus.where(seasons: { id: context.season_ids }) if context.season_ids
    end

    def load_season_ids
      return unless filter&.fetch(:season, nil).present?

      case filter[:season]
      when "current_season"
        Product.pluck(:current_season_id).compact.uniq
      else
        Season.where(name: filter[:season]).pluck(:id)
      end
    end
  end
end
