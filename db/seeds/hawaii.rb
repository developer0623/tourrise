# frozen_string_literal: true

module Seeds
  class Hawaii
    class << self
      def seed!
        pp "Seeding the Hawaii trip"

        create_resource_kingkam
        create_resource_royal_seacliff
        create_insurance
        create_resource_beachcruiser
        create_service_package
        create_island_hopping

        context = ::Products::CreateProduct.call!(params: product_params_de)
        I18n.with_locale :en do
          ::Products::UpdateProduct.call!(product: context.product, params: product_params_en)
        end
      end

      def product_params_de
        {
          "name" => "Wettkampfreise IM Hawaii 2020",
          "description" =>
          "Reise zum Ironman Hawaii 2020\r\n" \
            "\r\n" \
            "<p>\r\n" \
            "  Erlebe den Spirit vom IRONMAN Hawaii. Ob Athlet oder Zuschauer - wir garantieren eine unvergessliche Reise mit umfassendem Serviceangebot und viel Aloha.\r\n" \
            "</p>\r\n" \
            "\r\n" \
            "<p>\r\n" \
            "Sicherheit trotz Corona: Für Neubuchungen ab dem 01.04.2020: Du hast dich bereits für den IRONMAN Hawaii qualifiziert oder möchtest deine Mythos Reise nach Hawaii weiter planen? Wie geht es auf Grund der aktuellen Corona-Situation weiter? Leider wissen wir das auch nicht, doch wir schaffen alle finanziellen Risiken für dich aus dem Weg. Bei einer Buchung ab dem 01.04. hast du eine kostenfreie Stornierungsmöglichkeit bis zum 15.06.2020. Wir helfen dir sehr gerne bei einer individuellen Beratung weiter und besprechen mit dir die Details deiner Reise um dir die Entscheidung leicht zu machen. Auch eine Anzahlung muss vor diesem Termin nicht geleistet werden!\r\n" \
            "</p>\r\n",
          "published_at" => "2020-04-23 08:46:19 +0200",
          "cost_center_id" => "",
          "frontoffice_step_ids" => FrontofficeStep.all.pluck(:id),
          "financial_account_id" => "",
          "resource_ids" => resource_ids,
          "product_skus_attributes" => { "0" => { "handle" => "im-hi-2020" } }
        }.with_indifferent_access
      end

      def product_params_en
        {
          "name" => "Ironman World Championship Hawaii",
          "description" =>
          "Trip to Ironman World Championship Hawaii\r\n" \
            "\r\n" \
            "<p>\r\n" \
            "We guarantee you quality, a great atmosphere and all-round service for your trip. We do everything in our power to make sure each athlete stands perfectly prepared at the starting line und offer travelling companions an extensive event programm for an unforgettable trip to Hawaii.\r\n" \
            "</p>",
          "published_at" => "2020-04-23 08:50:15 +0200",
          "cost_center_id" => "",
          "financial_account_id" => "",
          "resource_ids" => resource_ids,
          "product_skus_attributes" => { "0" => { "id" => ProductSku.find_by_handle("im-hi-2020").id, "handle" => "im-hi-2020" } }
        }.with_indifferent_access
      end

      def create_resource_royal_seacliff
        params_de = {
          "resource_type_id" => ResourceType.accommodation.id,
          "name" => "Royal Sea Cliff",
          "teaser_text" => "Inmitten eines tropischen Gartens befindet sich die großzügig angelegte Anlage mit luxuriösen Unterkünften. Wahlweise Garten- oder Meerblick.",
          "description" => "Studios: Wohn-/Schlafraum mit Küche und 1 Doppelbett; Bad; für Einzelreisende oder Pärchen. 1-Schlafzimmer App.: Wohnraum mit Küche und Sofa; Schlafzimmer mit Doppelbett; Bad; für Einzelreisende oder Reisepärchen; 3- oder 4-er Belegung nur gemeinsam von Verwandten/Bekannten buchbar. 2-Schlafzimmer App.: Wohnraum mit Küche und Sofa, 2 Schlafzimmer, 2 Bäder; Wahlweise beide Schlafzimmer mit Doppelbett bzw. eines mit DB und eines mit 2 Einzelbetten. Zimmerbörse möglich. Parken: kostenlos Internetzugang: kostenlos Zimmerreinigung: wöchentlich Belegung: Alle Belegungsformen möglich Frühstück: Am besten im eigenen Appartement; die nächsten Restaurants befinden sich in Kailua-Kona.",
          "resource_skus_attributes" => {
            "0" => { "name" => "1-Schlafzimmer Appartment Garden View 1-er Belegung", "handle" => "rsc-sbdr-gv-soc" },
            "1" => { "name" => "1-Schlafzimmer Appartment Garden View 2-er Belegung", "handle" => "rsc-sbdr-gv-doc" }
          }
        }.with_indifferent_access

        context = ::Resources::CreateResource.call(params: params_de)

        if context.success?
          images = Dir["./db/seeds/images/rsc/*"].map do |filename|
            context.resource.images.attach(io: File.open(filename), filename: filename.split("/").last)
          end

          context.resource.resource_skus.each do |resource_sku|
            resource_sku.images.attach(io: File.open("./db/seeds/images/rsc/sku.jpg"), filename: "room")
          end
        end

        params_en = {
          "resource_type_id" => ResourceType.accommodation.id,
          "name" => "Royal Sea Cliff",
          "teaser_text" => "This establishment with its luxurious accommodation facilities is located on spacious grounds in the middle of a tropical garden. Choice of Garden or Ocean View.",
          "description" => "Studios: one large room incl. living room, kitchen and 1 double bed; bathroom; suitable for singles or couples.
          <br>\n

          1-bedroom apartment: Living room with kitchen and sofa; bedroom with 1 double bed; bathroom; suitable for singles or couples; 3 or 4 persons occupancy only with friends or relatives.

          2-bedroom apartment: Living room with kitchen and sofa, 2 bedrooms, 2 bathrooms; choice of either 2 double beds per bedroom or one with double bed, one with two single beds. Room sharing possible.

              Parking: free of charge
              Internet access: free of charge
              Room cleaning: weekly

          Occupation: All forms of occupation are possible.

          Breakfast: Best in your apartment; the closest restaurants are in Kailua-Kona.",
          "resource_skus_attributes" => {
            "0" => { "name" => "Single bedroom apartment garden view Single occupation", "handle" => "rsc-sbdr-gv-soc" },
            "1" => { "name" => "Single bedroom apartment garden view double occupation", "handle" => "rsc-sbdr-gv-doc" }
          }
        }.with_indifferent_access

        I18n.with_locale(:en) do
          ::Resources::UpdateResource.call(resource_id: ResourceSku.find_by_handle("rsc-sbdr-gv-soc").resource_id, params: params_en)
        end
      end

      def create_resource_kingkam
        params_de = {
          "resource_type_id" => ResourceType.accommodation.id,
          "name" => "King Kamehameha's Kona Beach Hotel",
          "teaser_text" =>
            "Das offizielle Race-Hotel liegt direkt am Start/Ziel des IRONMANs im Zentrum des Geschehens.",
          "description" =>
            "Das offizielle Race-Hotel liegt direkt am Start/Ziel des IRONMANs im Zentrum des Geschehens.\r\n" \
            "\r\n" \
            "Hier findet auch die IM Carbo-Party und Siegerehrung statt. Die umfangreiche Renovierung vor 3 Jahren hat das Hotel wieder zu einer beliebten Unterkunft gemacht. Unsere Zimmer (Gartenblick) sind sehr stilvoll eingerichtet, auch die Außenanlagen sind sehr ansprechend. Ein kleiner geschützter Sandstrand direkt vor der Haustüre sorgt für Urlaubsstimmung.\r\n" \
            "\r\n" \
            "    Parken: € 10,- pro Tag\r\n" \
            "    Internetzugang: kostenlos\r\n" \
            "    Zimmerreinigung: täglich\r\n" \
            "\r\n" \
            "Belegung: Alle Zimmer mit 2 großen Doppelbetten. Geeignet für Einzelreisende oder Reisepärchen. 3er-/4er-Belegung kann nur gemeinsam von Verwandten oder Bekannten gebucht werden. \r\n" \
            "\r\n" \
            "Frühstück/Abendessen: Beides ist im Hotel oder in der unmittelbaren Umgebung möglich. Zum Supermarkt sind es nur wenige Meter.\r\n",
          "resource_skus_attributes" =>
            { "0" => { "name" => "Studio Standard 1er Belegung", "handle" => "kika-std-1p" },
              "1" => { "name" => "Studio Standard 2er Belegung", "handle" => "kika-std-2p" } }
        }.with_indifferent_access

        context = ::Resources::CreateResource.call(params: params_de)

        if context.success?
          images = Dir["./db/seeds/images/kika/*"].map do |filename|
            context.resource.images.attach(io: File.open(filename), filename: filename.split("/").last)
          end

          context.resource.resource_skus.each do |resource_sku|
            resource_sku.images.attach(io: File.open("./db/seeds/images/kika/sku.jpg"), filename: "room")
          end
        end

        params_en = {
          "resource_type_id" => ResourceType.accommodation.id,
          "name" => "King Kamehameha's Kona Beach Hotel",
          "teaser_text" => "The official race hotel is right at the start / finish of the IRONMAN in the center of the action.",
          "description" => "The IM Carbo Party and award ceremony also take place here. The extensive renovation 3 years ago has made the hotel a popular accommodation again. Our rooms (garden view) are very stylishly furnished, the outdoor facilities are also very appealing. A small sheltered sandy beach right in front of the front door creates a holiday mood.

    Parking: € 10 per day
    Internet access: free of charge
    Housekeeping: daily

Occupancy: All rooms with 2 large double beds. Suitable for single travelers or couples. Triple / 4-person occupancy can only be booked together by relatives or acquaintances.

Breakfast / Dinner: Both are possible in the hotel or in the immediate vicinity. It is only a few meters to the supermarket.",
          "resource_skus_attributes" => {
            "0" => {
              "name" => "Studio Standard Single Occupancy", "handle" => "kika-std-1p", "id" => ResourceSku.find_by_handle("kika-std-1p").id
            },
            "1" => {
              "name" => "Studio Standard Double Occupancy", "handle" => "kika-std-2p", "id" => ResourceSku.find_by_handle("kika-std-2p").id
            }
          }
        }.with_indifferent_access

        I18n.with_locale(:en) do
          ::Resources::UpdateResource.call(resource_id: ResourceSku.find_by_handle("kika-std-1p").resource_id, params: params_en)
        end
      end

      def create_resource_beachcruiser
        params_de = {
          "resource_type_id" => ResourceType.rentalbike.id,
          "name" => "Beachcruiser",
          "teaser_text" => "Unsere Beachcruiserflotte auf Hawaii",
          "description" => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guberg",
          "resource_skus_attributes" => {
            "0" => { "name" => "Beachcruiser", "handle" => "rentalbike-beachcruiser-hawaii" }
          }
        }.with_indifferent_access

        ::Resources::CreateResource.call(params: params_de)

        params_en = {
          "resource_type_id" => ResourceType.rentalbike.id,
          "name" => "Beachcruiser",
          "teaser_text" => "Our beachcruiser fleet on Hawaii.",
          "description" => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guberg",
          "resource_skus_attributes" => {
            "0" => { "name" => "Beachcruiser", "handle" => "rentalbike-beachcruiser-hawaii", "id" => ResourceSku.find_by_handle("rentalbike-beachcruiser-hawaii").id }
          }
        }.with_indifferent_access

        I18n.with_locale(:en) do
          ::Resources::UpdateResource.call(resource_id: ResourceSku.find_by_handle("rentalbike-beachcruiser-hawaii").resource_id, params: params_en)
        end
      end

      def create_insurance
        params_de = {
          "resource_type_id" => ResourceType.insurance.id,
          "name" => "Versicherung",
          "teaser_text" =>
            "Unsere Versicherungsoptionen",
          "description" => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guberg",
          "resource_skus_attributes" => {
            "0" => { "name" => "Auslandskrankenversicherung", "handle" => "IN0103" },
            "1" => { "name" => "Reiserücktritt/-abbruch", "handle" => "IN0101" },
            "2" => { "name" => "Rundum Sorglos Paket", "handle" => "IN0102" }
          }
        }.with_indifferent_access

        ::Resources::CreateResource.call(params: params_de)

        params_en = {
          "resource_type_id" => ResourceType.insurance.id,
          "name" => "Our insurance options",
          "teaser_text" => "The official race hotel is right at the start / finish of the IRONMAN in the center of the action.",
          "description" => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guberg",
          "resource_skus_attributes" => {
            "0" => { "name" => "Health insurance abroad", "handle" => "IN0103", "id" => ResourceSku.find_by_handle("IN0103").id },
            "1" => { "name" => "Cancellation insurance", "handle" => "IN0101", "id" => ResourceSku.find_by_handle("IN0101").id },
            "2" => { "name" => "All-round carefree insurance package", "handle" => "IN0102", "id" => ResourceSku.find_by_handle("IN0102").id }
          }
        }.with_indifferent_access

        I18n.with_locale(:en) do
          ::Resources::UpdateResource.call(resource_id: ResourceSku.find_by_handle("IN0103").resource_id, params: params_en)
        end
      end

      def create_service_package
        params_de = {
          "resource_type_id" => ResourceType.training_package.id,
          "name" => "Servicepaket",
          "teaser_text" => "Unser Servicepaket beinhaltet die Rund-Um Betreuung durch dein HHT-Team vor Ort sowie alle Veranstaltungen und Trainingseinheiten. Wenn du Hotel und/oder Flug über uns buchst, ist das Servicepaket fester Bestandteil deiner Reiseleistungen. ",
          "description" => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guberg",
          "resource_skus_attributes" => {
            "0" => { "name" => "Begleitperson-Paket", "handle" => "training-package-guest" },
            "1" => { "name" => "Guide-Paket", "handle" => "training-package-guide" },
            "2" => { "name" => "Mythos-Paket", "handle" => "training-package-mythos" },
            "3" => { "name" => "Service-Paket", "handle" => "training-package-service" },
            "4" => { "name" => "Sport-Paket", "handle" => "training-package-sport" }
          }
        }.with_indifferent_access

        ::Resources::CreateResource.call(params: params_de)

        params_en = {
          "resource_type_id" => ResourceType.training_package.id,
          "name" => "Servicepackages",
          "teaser_text" => "Our service package includes all-round support from your local HHT team as well as all events and training units. If you book a hotel and / or flight through us, the service package is an integral part of your travel services.",
          "description" => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guberg",
          "resource_skus_attributes" => {
            "0" => { "name" => "Companion package", "handle" => "training-package-guest", "id" => ResourceSku.find_by_handle("training-package-guest").id },
            "1" => { "name" => "Guide package", "handle" => "training-package-guide", "id" => ResourceSku.find_by_handle("training-package-guide").id },
            "2" => { "name" => "Mythos package", "handle" => "training-package-mythos", "id" => ResourceSku.find_by_handle("training-package-mythos").id },
            "3" => { "name" => "Service package", "handle" => "training-package-service", "id" => ResourceSku.find_by_handle("training-package-service").id },
            "4" => { "name" => "Athlete package", "handle" => "training-package-sport", "id" => ResourceSku.find_by_handle("training-package-sport").id }
          }
        }.with_indifferent_access

        I18n.with_locale(:en) do
          ::Resources::UpdateResource.call(resource_id: ResourceSku.find_by_handle("training-package-guest").resource_id, params: params_en)
        end
      end

      def create_island_hopping
        params_de = {
          "resource_type_id" => ResourceType.island_hopping.id,
          "name" => "Inselhopping auf Hawaii",
          "teaser_text" => "Ob Oahu, Maui oder Kauai - jede der hawaiianischen Inseln hat ihren eigenen Charme und lädt zu einem Besuch ein. (Preise 2020 coming soon)",
          "description" => "DIE HAWAIIANISCHEN INSELN Die hawaiianischen Inseln liegen nur wenige Flugminuten voneinander entfernt. Wenn man schon um die halbe Welt geflogen ist, warum dann nicht auch noch Maui, Oahu oder Kauai besuchen? Jede dieser Inseln hat wie Big Island ihren ganz besonderen Charme. Auch wenn es nur 2 Tage pro Insel sind - es lohnt sich - je länger desto besser! FLÜGE Flüge verkehren mehrmals täglich. Es empfiehlt sich neben dem Hotel auch einen Mietwagen zu buchen. Deine Heimreise kannst Du entweder von der letzten Insel oder nach einem Inselflug ab Kailua-Kona starten. Im letzteren Fall kannst du unseren Kona-Gepäckservice nutzen und nur mit Handgepäck von Insel zu Insel reisen. ",
          "resource_skus_attributes" => {
            "0" => { "name" => "PAKET 1: MAUI - RELAX 12.10. - 16.10.", "handle" => "ih-maui" },
            "1" => { "name" => "PAKET 2: KAUAI - NATUR PUR 12.10. - 16.10.", "handle" => "ih-kauai" },
            "2" => { "name" => "PAKET 3: MAUI - KAUAI 12.10. - 19.10.", "handle" => "ih-maui-kauai" },
            "3" => { "name" => "PAKET 4: INDIVIDUELL", "handle" => "ih-indi" }
          }
        }.with_indifferent_access

        ::Resources::CreateResource.call(params: params_de)

        params_en = {
          "resource_type_id" => ResourceType.island_hopping.id,
          "name" => "Island hopping in Hawaii",
          "teaser_text" => "Whether Oahu, Maui or Kauai - each of the Hawaiian Islands has its own charm and invites you to visit. (Prices 2020 coming soon)",
          "description" => "THE HAWAIIAN ISLANDS The Hawaiian Islands are only a few minutes' flight away. If you have flown halfway around the world, why not visit Maui, Oahu or Kauai? Like Big Island, each of these islands has its own special charm. Even if it's only 2 days per island - it's worth it - the longer the better! FLIGHTS Flights operate several times a day. It is advisable to book a rental car in addition to the hotel. You can start your journey home either from the last island or after an island flight from Kailua-Kona. In the latter case, you can use our Kona luggage service and only travel from island to island with hand luggage.",
          "resource_skus_attributes" => {
            "0" => { "name" => "Package 1: Maui", "handle" => "ih-maui", "id" => ResourceSku.find_by_handle("ih-maui").id },
            "1" => { "name" => "Package 2: Kauai", "handle" => "ih-kauai", "id" => ResourceSku.find_by_handle("ih-kauai").id },
            "2" => { "name" => "Package 3: Maui - Kauai", "handle" => "ih-maui-kauai", "id" => ResourceSku.find_by_handle("ih-maui-kauai").id },
            "3" => { "name" => "Package 4: Indi", "handle" => "ih-indi", "id" => ResourceSku.find_by_handle("ih-indi").id }
          }
        }.with_indifferent_access

        I18n.with_locale(:en) do
          ::Resources::UpdateResource.call(resource_id: ResourceSku.find_by_handle("ih-maui").resource_id, params: params_en)
        end
      end

      def resource_ids
        ResourceSku.where(handle: %i[IN0101 rentalbike-beachcruiser-hawaii kika-std-1p rsc-sbdr-gv-soc training-package-guest ih-maui]).pluck(:resource_id)
      end
    end
  end
end
