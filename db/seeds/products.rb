module Seeds
  class Products
    def self.seed!
      pp "Seeding Products"
      create_tri_camp_pmi
      create_competition_product
      create_allgaeu_tri
    end

    def self.create_tri_camp_pmi
      product = Product.where(name: 'Trainingslager auf Mallorca').first_or_create do |product|
        product.name = 'Trainingslager auf Mallorca'
        product.published_at = Date.current
        product.frontoffice_steps = FrontofficeStep.where(handle: %w[request accommodation_request flight_request rentalbike_request training_package_request insurance_request contact participants summary])
        product.description = 'Geführte Radgruppen, Lauf- und Schwimmtraining, Cappuccinopausen mit Erdbeerkuchen, Athletiktraining und vieles mehr.'
        product.product_skus << product.product_skus.new(name: 'Trainingslager Cala Rattata', handle: 'tl-pmi')
      end
    end

    def self.create_competition_product
      product = Product.where(name: 'Wettkampfreise Ironman Cozumel').first_or_create do |product|
        product.name = 'Wettkampfreise Ironman Cozumel'
        product.published_at = Date.current
        product.description = "REISE ZUM IRONMAN COZUMEL\n
      Herein ins Paradies! Wahrscheinlich gibt es nur wenige Rennen auf der Welt, die sich so sehr lohnen wie der IRONMAN Cozumel. Hier verbindest Du den Wettkampf mit einem Urlaub in der Karibik, der seines gleichen suchen wird. Lasse Dich verzaubern."
        product.frontoffice_steps = FrontofficeStep.where(handle: %w[request accommodation_request flight_request rentalbike_request rentalcar_request insurance_request contact participants summary])
        product.product_skus << product.product_skus.new(name: 'IM Cozumel 2019', handle: 'im-coz-19')
      end
    end

    def self.create_allgaeu_tri
      resource = Resource.find_by(name: 'Athletencamping am Alpsee')
      product = Product.where(name: 'Allgaeutriathlon').first_or_create do |product|
        product.name = 'Allgaeutriathlon Travel'
        product.published_at = Date.current
        product.description = "Mit Hannes Hawaii Tours zum ALLGÄU TRIATHLON \n Wir haben für alle Teilnehmer des Allgäu Triathlons wieder exklusiv die attraktivsten Unterkünfte in und um Immenstadt reserviert."
        product.frontoffice_steps = FrontofficeStep.where(handle: %w[request accommodation_request rentalbike_request insurance_request contact participants summary])
        product.product_skus << product.product_skus.new(name: 'Allgaeu Triathlon Reise', handle: 'at-travel')
        product.resources << resource
      end
    end
  end
end
