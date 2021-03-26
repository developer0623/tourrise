# frozen_string_literal: true

module CsvExports
  class GenerateProductParticipantsCsvExport
    include Interactor
    include DateHelper

    HEADERS = [
      "Buchungsnummer",
      "Produkt",
      "Produktvariante",
      "Beginn Reise",
      "Ende Reise",
      "Kontakt Name",
      "Kontakt Telefon",
      "Kontakt Email",
      "Reisegast",
      "Geburtsdatum",
      "Alter zu Reisebeginn",
      "Email"
    ].freeze

    def call
      context.csv = generate_csv
    end

    private

    def generate_csv
      CSV.generate(headers: true) do |csv|
        csv << HEADERS

        context.booking_participants.except(:limit).find_each do |booking_participant|
          csv << [
            booking_participant.id,
            booking_participant.product_name,
            booking_participant.product_sku_name,
            booking_participant.booking_starts_on,
            booking_participant.booking_ends_on,
            booking_participant.participant_name,
            booking_participant.customer_phone.to_s,
            booking_participant.customer_email,
            booking_participant.customer_name,
            booking_participant.participant_birthdate,
            calculate_age(booking_participant.participant_birthdate, booking_participant.booking_starts_on),
            booking_participant.participant_email
          ]
        end
      end
    end
  end
end
