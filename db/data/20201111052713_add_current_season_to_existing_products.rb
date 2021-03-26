class AddCurrentSeasonToExistingProducts < ActiveRecord::Migration[6.0]
  def up
    Product.all.each do |product|
      next if product.seasons.any?

      season = product.seasons.create!(
        name: "Eine neue Saison",
        published_at: product.published_at,
        product_skus: product.product_skus
      )

      product.bookings.update_all(season_id: season.id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
