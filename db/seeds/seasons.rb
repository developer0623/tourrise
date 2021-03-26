module Seeds
  class Seasons
    def self.seed!
      pp "Seeding Seasons"

      Product.all.each do |product|
        product.seasons.create(name: 1.year.ago.year)
        product.update_attribute(
          :current_season,
          product.seasons.create(name: Time.zone.today.year, published_at: 6.months.ago)
        )
        product.seasons.create(name: 1.year.from_now.year)

        product.product_skus.each do |product_sku|
          product_sku.seasons << product.seasons
        end
      end
    end
  end
end
