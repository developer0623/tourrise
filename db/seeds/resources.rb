module Seeds
  class Resources
    def self.seed!
      pp "Seeding Resources"
      create_child_care
      create_trainings_package
      create_athlete_camping
      create_transfer
      create_insurances
    end

    def self.create_trainings_package
      resource = Resource.where(name: 'Trainingspaket').first_or_create do |resource|
        resource.name = 'Trainingspaket'
        resource.description = '
<strong>Trainingskonzept</strong>
<p>Alle unsere Camps basieren auf über 30 Jahren Erfahrung und wurden Jahr für Jahr weiterentwickelt. Im Wochenverlauf kommt nach den ersten drei Trainingstagen ein Ruhetag gefolgt auf zwei weitere Traningstage der nächste Ruhetag. Unsere Mustertrainingspläne variieren zwischen 10 und 30 Trainingsstunden pro Woche. Angepasst an Dein Ausgangsniveau und Deine Wünsche.</p>

<strong>Trainer / Guides</strong>
<p>Wir freuen uns mit den besten Trainern der Szene zusammenarbeiten zu dürfen. Bei uns schreibt ein Trainer nicht nur eine Trainingsempfehlung, sondern ist 24 Stunden und 7 Tage die Woche für Dich im Camp da. Olympiateilnehmer, Weltmeistertrainer, Nationalmanschaftsmitglieder, A-Lizenz Trainer, die Liste könnte noch deutlich verlängert werden. Unsere Anhänger nehmen sich für jeden, vom Einsteiger bis zum Profi, ausführlich Zeit und freuen sich auf Deine Fragen. Lass Dich inspirieren!</p>

<strong>Unterkunft</strong>
<p>Das Playitas ist eines der größten Sportresorts in Europa und von der Sportinfrastruktur gepaart mit dem Klima und den Straßenverhältnissen der Insel Fuerteventura die klare Nummer 1. Sportlergerechtes Essen, ein olympischer Pool mit wohltemperierten 27 Grad, kilometerlange Laufstrecken, einfach alles was das Triathlonherz begehrt.  </p>

<strong>Mieträder</strong>
<p>Unsere Trainingsstätten sind immer mit top Radmaterial ausgestattet. Stressfrei und leicht ohne Radkoffer reisen und sich auf ein optimal auf Dich eingestelltes Rad freuen ist somit spielend leicht. Die neuesten Garmin Navigationsgeräte oder Zipp Laufräder  kannst Du Dir tageweise bei uns ausleihen um sie auf Herz und Nieren zu testen.</p>

<strong>Werkstatt</strong>
<p>Ein erfahrener Mechaniker gehört bei HHT zu jedem Trainingslager und jeder Wettkampfreise. Auch für Ersatzmaterial ist gesorgt. Bei schwierigeren Fällen haben wir Partnerradshops vor Ort und finden immer eine Lösung für Dich.</p>

<strong>Flughafen Transfer</strong>
<p>Reisen mit viel Gepäck und gerade Rädern ist für uns Triathleten normal, für viele Transfergesellschaften und Fluglinien die Ausnahme. Wir sorgen für einen reibungslosen Ablauf und haben noch jede Radbox unfallfrei zum Ziel gebracht.</p>

<strong>Flug</strong>
<p>Wir wissen was Triathleten brauchen und finden für Deine Präferenzen den besten Flug. Egal ob es sich um die Flugzeiten, Abflugorte, Flugpreise oder die Gepäckbestimmungen geht. Du sagst uns, was Dir wichtig ist und wir finden den für Dich passenden Flug und das alles zu Internetpreisen!</p>

<strong>Mietwagen</strong>
<p>Am Ruhetag die Insel auf eigene Faust mit einem Mietwagen erkunden? Leihe Dir von unserem Partner Mercedes Benz unsere HHT V-Klasse aus oder sag uns, welchen Mietwagen wir Dir organisieren sollen.</p>
        '
        resource.resource_type = ResourceType.find_by(handle: :basic)
        resource.resource_skus << resource.resource_skus.new(
          name: 'Trainingspaket 1 Woche',
          handle: 'trainings-package-1w',
          resource_sku_pricings_attributes: [{ price: 250.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Trainingspaket 2 Wochen',
          handle: 'trainings-package-2w',
          resource_sku_pricings_attributes: [{ price: 450.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Trainingspaket Zusatztag',
          handle: 'trainings-package-1d',
          resource_sku_pricings_attributes: [{ price: 50.00, calculation_type: :fixed }]
        )
      end
      resource
    end

    def self.create_child_care
      resource = Resource.where(name: 'Kinderbetreuung').first_or_create do |resource|
        resource.name = 'Kinderbetreuung'
        resource.description = 'Der Miniclub (4-12 J.) hat von 9:30–13 Uhr und von 15:30-20 Uhr geöffnet. Jüngere Kinder müssen in Begleitung eines Erwachsenen sein. Kids Academy: in der Ferienzeit werden Kinder in verschiedenen Sportarten speziell gefördert. Weitere Infos auf Anfrage.'
        resource.resource_type = ResourceType.find_by(handle: :basic)
        resource.resource_skus << resource.resource_skus.new(
          name: 'Kinderbetreuung',
          handle: 'child-care',
          resource_sku_pricings_attributes: [{ price: 25.00, calculation_type: :per_person_and_night }]
        )
      end
    end

    def self.create_transfer
      resource = Resource.where(name: 'Transfer').first_or_create do |resource|
        resource.name = 'Transfer'
        resource.description = 'Wie können diverse Transfers anbieten'
        resource.resource_type = ResourceType.transfer
        resource.resource_skus << resource.resource_skus.new(
          name: 'Flughafentransfer',
          handle: 'airport-transfer'
        )
      end
    end

    def self.create_athlete_camping
      inventory_params = {
        name: "Athletencamping große Camper",
        inventory_type: :quantity_in_date_range,
        availabilities_attributes: [
          {
            quantity: 20,
            starts_on: 2.weeks.from_now,
            ends_on: 3.weeks.from_now
          },
          {
            quantity: 15,
            starts_on: 2.weeks.from_now + 2.days,
            ends_on: 3.weeks.from_now - 1.day
          }
        ]
      }
      inventory1 = Inventory.create(inventory_params)
      inventory_params = {
        name: "Athletencamping kleine Camper",
        inventory_type: :quantity_in_date_range,
        availabilities_attributes: [
          {
            quantity: 4,
            starts_on: 2.weeks.from_now,
            ends_on: 3.weeks.from_now
          },
          {
            quantity: 8,
            starts_on: 2.weeks.from_now + 2.days,
            ends_on: 3.weeks.from_now - 1.day
          }
        ]
      }
      inventory2 = Inventory.create(inventory_params)
      resource = Resource.where(name: 'Athletencamping am Alpsee').first_or_initialize do |resource|
        resource.name = 'Athletencamping am Alpsee'
        resource.description = 'Die Stellplätze werden pro Person & Nacht abgerechnet. Zusatzoptionen gibt es eigentlich nicht. Minimum Stay 2 Nächte'
      end
      sku1 = resource.resource_skus.new(
        name: 'Fahrzeuglänge länger als 5,50m',
        handle: 'camping-lt-550',
        resource_sku_pricings_attributes: [{ price: 35.00, calculation_type: :per_person_and_night }]
      )
      sku1.inventories << inventory1
      sku2 = resource.resource_skus.new(
        name: 'Fahrzeuglänge kürzer als 5,50m',
        handle: 'camping-gt-550',
        resource_sku_pricings_attributes: [{ price: 15.00, calculation_type: :per_person_and_night }]
      )
      sku2.inventories << inventory2
      resource.resource_skus = [sku1, sku2]
      resource.resource_type = ResourceType.accommodation
      resource.save!
      resource
    end

    def self.create_insurances
      resource = Resource.where(name: 'Versicherung').first_or_create do |resource|
        resource.name = 'Versicherung'
        resource.description = 'Abhängig vom Reisepreis'
        resource.resource_type = ResourceType.find_by(handle: :insurance)
        resource.resource_skus << resource.resource_skus.new(
          name: 'Reiserücktrittsversicherung mit Reiseabbruchversicherung bis 400 EURO',
          handle: 'rrv+rab1',
          description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
          resource_sku_pricings_attributes: [{ price: 30.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Reiserücktrittsversicherung mit Reiseabbruchversicherung bis 2000 EURO',
          handle: 'rrv+rab2',
          description: '<strong>Why do we use it?</strong><p>It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem</p>',
          resource_sku_pricings_attributes: [{ price: 150.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Reiserücktrittsversicherung mit Reiseabbruchversicherung bis 5000 EURO',
          handle: 'rrv+rab3',
          resource_sku_pricings_attributes: [{ price: 400.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Rundum-Sorglos-Versicherungspaket bis 2000 EURO',
          handle: 'rsv1',
          resource_sku_pricings_attributes: [{ price: 150.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Rundum-Sorglos-Versicherungspaket',
          handle: 'rsv2',
          resource_sku_pricings_attributes: [{ price: 30.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Gepäckversicherung bis 2000 EURO',
          handle: 'rsv3',
          resource_sku_pricings_attributes: [{ price: 10.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Gepäckversicherung bis 4000 EURO',
          handle: 'rsv4',
          resource_sku_pricings_attributes: [{ price: 25.00, calculation_type: :fixed }]
        )
        resource.resource_skus << resource.resource_skus.new(
          name: 'Gepäckversicherung bis 6000 EURO',
          handle: 'rsv5',
          resource_sku_pricings_attributes: [{ price: 50.00, calculation_type: :fixed }]
        )
      end
      resource
    end
  end
end
