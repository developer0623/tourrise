class AddProductSkuConfigurationToSeasonalProductSku < ActiveRecord::Migration[6.0]
  def up
    SeasonalProductSku.transaction do
      ProductSkuBookingConfiguration.all.each do |configuration|
        season = configuration.product_sku.product.seasons.last
        seasonal_product_sku = SeasonalProductSku.find_or_initialize_by(season: season, product_sku_id: configuration.product_sku_id)
 
        seasonal_product_sku.starts_on = configuration.starts_on
        seasonal_product_sku.ends_on = configuration.ends_on

        seasonal_product_sku.save!
      end
    end
  end

  def down
    SeasonalProductSku.all.update_all(starts_on: nil, ends_on: nil)
  end
end
