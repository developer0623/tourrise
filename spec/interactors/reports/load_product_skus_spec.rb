# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reports::LoadProductSkus, type: :interactor do
  subject(:context) { described_class.call }

  let!(:product) { create(:product) }

  describe '.call' do
    it 'loads the product skus' do
      expect(context.product_skus.pluck(:id)).to eq(product.product_skus.pluck(:id))
    end

    context 'with season name filter enabled' do
      let!(:a_product_without_a_season) { create(:product) }
      let!(:a_product_with_a_different_season) { create(:product) }

      before do
        season = product.seasons.create(name: "New Season")
        season.product_skus << product.product_skus

        different_season = a_product_with_a_different_season.seasons.create(name: "Different Season")
        different_season.product_skus << a_product_with_a_different_season.product_skus
      end

      subject(:context) { described_class.call(filter: { season: "New Season" }) }

      it 'only loads the product skus data for the requested season' do
        expect(context.product_skus.pluck(:id)).to eq(product.product_skus.pluck(:id))
      end

      it 'adds the season_ids to the context' do
        expect(context.season_ids).to eq(product.seasons.pluck(:id))
      end
    end

    context 'with current_season filter enabled' do
      let!(:a_product_without_a_season) { create(:product) }
      let!(:a_product_with_a_different_season) { create(:product) }

      before do
        season = product.seasons.create(name: "New Season")
        season.product_skus << product.product_skus
        product.update_attribute(:current_season, season)

        different_season = a_product_with_a_different_season.seasons.create(name: "Different Season")
        different_season.product_skus << a_product_with_a_different_season.product_skus
      end

      subject(:context) { described_class.call(filter: { season: "current_season" }) }

      it 'only loads the product_skus data for their current season' do
        expect(context.product_skus.pluck(:id)).to eq(product.product_skus.pluck(:id))
      end

      it 'adds the season_ids to the context' do
        expect(context.season_ids).to contain_exactly(product.current_season.id)
      end
    end
  end
end
