module Seeds
  class CampFuerteventura
    class << self
      def seed!
        pp "Seeding the Camp Fuerteventura"
        create_product
        create_resources

        @product.resources = [
          @aparthotel,
          @hotel,
          @service_package,
          @rentalbike
        ]
        @product.save
      end

      private

      def create_product
        @product ||= Product.where(name: 'Trainingslager auf Fuerteventura').first_or_create do |product|
          product.name = 'Trainingslager auf Fuerteventura'
          product.frontoffice_steps = FrontofficeStep.where(handle: %w[request accommodation_request flight_request rentalbike_request training_package_request insurance_request contact participants summary])
          product.description = '<p><strong>Auf der „Insel des ewigen Sommers“ bietet das Las Playitas die perfekte Trainingslocation für Triathleten jeder Leistungsgruppe</strong></p><p>Top-Unterkünfte und Essen, 50m-Pool (mit Plexiglas-Fenster!), Kraftraum, gute Laufstrecken mit einer 400m-Bahn nur wenige Kilometer entfernt und Radtouren mit sehr gutem Straßenbelag. Hannes Hawaii Tours bietet in Zusammenarbeit mit dem Las Playitas eine Triathlonstation von November bis April mit kompetentem Team für Training, Mechanik und Theorie! Neben den Schwimm-Camps im November/Dezember kannst Du in unseren Triathlon-Trainingscamps ab Januar an Deiner Form feilen. Wir freuen uns auf schöne Wochen mit Euch allen im und um das „Las Playitas“!<p>'
          product.product_skus << product.product_skus.new(
            name: 'Schwimmcamp',
            handle: 'swim-1-19'
          )
          product.product_skus << product.product_skus.new(
            name: 'Triathloncamp 1',
            handle: 'tri-1-19'
          )
          product.product_skus << product.product_skus.new(
            name: 'Triahtloncamp 2',
            handle: 'tri-2-19'
          )
          product.product_skus << product.product_skus.new(
            name: 'Triathloncamp 3',
            handle: 'tri-3-19'
          )
          product.product_skus << product.product_skus.new(
            name: 'Runners World Camp',
            handle: 'run-1-20'
          )
        end
      end

      def create_resources
        @aparthotel = create_aparthotel
        @hotel = create_hotel
        @service_package = create_service_package
        @rentalbike = create_rentalbike
      end

      def create_aparthotel
        resource = Resource.new(
          name: 'Las Playitas Aparthotel',
          resource_type: ResourceType.find_by_handle!(:accommodation),
          description: '
<p>
Das Aparthotel ist das ideale Familienhotel. Es besteht aus einem Hauptgebäude und mehreren Seitengebäuden mit insgesamt 96 Apartments und 114 Studios. Alle Appartements und Studios sind sehr wohnlich eingerichtet und verfügen entweder über einen Balkon oder eine Terrasse. Die Studios bieten 2 bis 4 Betten in einem großen Raum welcher auf zwei Ebenen unterteilt ist.
Die Appartements haben die gleichen Einrichtungen wie die Studios, sind jedoch mit 2 bis 5 Betten ausgestattet welche auf ein Schlafzimmer (3 Betten) und ein Wohnzimmer (2 Betten) verteilt sind.
</p>
<p>
Im Erdgeschoss des Aparthotels liegen neben der rund um die Uhr besetzten Rezeption ein Supermarkt, ein self-service Waschsalon und das große Büffet-Restaurant Bahia Grande, in dem das Frühstück sowie das Abendessen eingenommen werden können. Am Swimmingpool gibt es eine Bar mit Lunch- und Snack-Angeboten.
</p>
<p><strong>Alle Zimmer sind mit Latexmatratzen ausgestattet und sorgen somit für einen gesunden Schlaf.</strong></p>
'
        )

        resource.resource_skus.new(
          name: 'Studio 1er Belegung',
          handle: 'FUE20-15',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 210.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 190.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 135.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Studio 2er Belegung',
          handle: 'FUE20-16',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 170.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 155.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 95.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Studio 3er Belegung',
          handle: 'FUE20-17',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 155.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 140.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 80.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Appartment 2er Belegung',
          handle: 'FUE20-18',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 190.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 170.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 100.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Appartment 3er Belegung',
          handle: 'FUE20-19',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 170.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 155.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 90.00
            }
          ]
        )

        resource.save!
        resource
      end

      def create_hotel
        resource = Resource.new(
          name: 'Las Playitas Hotel',
          resource_type: ResourceType.find_by_handle!(:accommodation),
          description: '
<p>Das Playitas Hotel ist der ruhigere Teil der gesamten Anlage, Familien sind größtenteils im Bahia Grande untergebracht. Das Hotel gleicht einem Mini-Dorf und bietet durch die Lage am Berghang eine fantastische Sicht auf die schöne Gartenanlage sowie auf den Atlantik.</p>
<p>Das Hauptgebäude ist zweigeschossig, ein kleiner Fahrstuhl verfrachtet die Gäste bis hin zu den Seitengebäuden. In einem kleinen Supermarkt erhält man Kleinigkeiten wie Getränke, Süßigkeiten, Sonnencreme oder Zeitschriften.</p>
<p>Insgesamt gibt es 223 Zimmer – hierunter Junior-Suiten und die exklusiven Pool-Suiten, in denen man das Luxusleben mit eigenem Swimmingpool genießen kann. Im Restaurant des Hotels wird das Frühstücks- und Abendbüffet serviert. Drinks, Lunch- oder Imbissangebote gibt es in der Palapa Bar, die ebenfalls Meerblick bietet.</p>
<p><strong>Gegen Aufpreis: Ausblick aufs Meer und auf den Golfplatz (in Luxus-Suiten bereits enthalten).</strong></p>
<p>Alle Zimmer sind mit Latexmatratzen ausgestattet und sorgen somit für einen gesunden Schlaf.</p>
          '
        )

        resource.resource_skus.new(
          name: 'Standardzimmer 1er Belegung',
          handle: 'FUE20-10',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 200.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 180.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 120.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Standardzimmer 2er Belegung',
          handle: 'FUE20-11',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 155.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 140.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 90.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Junior Suite 1er Belegung',
          handle: 'FUE20-12',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 230.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 200.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 140.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Junior Suite 2er Belegung',
          handle: 'FUE20-13',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 170.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 155.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 100.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Junior Suite 3er Belegung',
          handle: 'FUE20-14',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 155.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 140.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 85.00
            }
          ]
        )

        resource.save!
        resource
      end

      def create_service_package
        resource = Resource.new(
          name: 'Leistungspakete vor Ort',
          resource_type: ResourceType.find_by_handle!(:basic),
          description: '
<strong>Servicepaket</strong>
<ul>
  <li>HHT-Zentrale / Reiseleitung</li>
  <li>Gastgeschenk</li>
  <li>Testcenter</li>
  <li>Mechaniker vor Ort</li>
</ul>
<strong>Sportpaket</strong>
Leistungen des Servicepakets inbegriffen
<ul>
  <li>Flughafentransfers (inkl. Rad)</li>
  <li>Sportliche Leitung mit Trainern</li>
  <li>geleitetes Schwimmtraining / Technikkurse</li>
  <li>geführte Radgruppen</li>
  <li>Fahrsicherheitstraining</li>
  <li>Lauftraining / Lauf-ABC</li>
  <li>Koppel- und Wechseltraining</li>
  <li>Funktionsgymnastik</li>
  <li>Seminare und Workshops</li>
  <li>Fahrbereitschaft während des Radtrainings</li>
  <li>reservierte Poolbahnen</li>
</ul>
          '
        )

        resource.resource_skus.new(
          name: 'Sportpaket',
          handle: 'FUE20-20',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 50.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 25.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 20.00
            }
          ]
        )

        resource.resource_skus.new(
          name: 'Servicepaket',
          handle: 'FUE20-30',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 25.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 15.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 10.00
            }
          ]
        )

        resource.save!
        resource
      end

      def create_rentalbike
        resource = Resource.new(
          name: 'Mietrad',
          resource_type: ResourceType.find_by_handle!(:basic),
          description: '
<p>Spar Dir den Rad-Pack-Stress und die Transportgebühren: Gegen einen Aufpreis von 20,- € pro Tag ab 2 Wochen bzw. 25,- € pro Tag ab 1 Woche erhältst Du ein hochwertiges Mietrad vor Ort! Bitte gib bei der Anmeldung Deine Körpergröße an.</p>
          '
        )

        resource.resource_skus.new(
          name: 'Mietrad',
          handle: 'FUE20-50',
          resource_sku_pricings_attributes: [
            {
              calculation_type: :per_person_and_night,
              price: 30.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 7,
              price: 25.00
            },
            {
              calculation_type: :per_person_and_night,
              min_quantity: 14,
              price: 20.00
            }
          ]
        )

        resource.save!
        resource
      end
    end
  end
end
