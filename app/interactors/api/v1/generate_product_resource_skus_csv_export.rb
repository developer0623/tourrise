# frozen_string_literal: true

module Api
  module V1
    class GenerateProductResourceSkusCsvExport
      include Interactor
      include DateHelper

      VALID_OPERATORS = {
        lt: "<",
        gt: ">"
      }.freeze

      HEADERS = [
        "Buchungsnummer",
        "Buchungsstatus",
        "Reisegast Vorname",
        "Reisegast Nachname",
        "Saison",
        "Produktname",
        "Produktvariantenname",
        "Beginn Reise",
        "Ende Reise",
        "Ressource",
        "Sku",
        "Handle",
        "Preis Stück",
        "Anzahl",
        "Gesamtpreis",
        "Anmerkungen",
        "reservation_id",
        "Iventory name"
      ].freeze

      delegate :product_sku_handle, :filter, to: :context

      def call
        context.fail!(message: "missing parameter product_sku_handle") unless product_sku_handle.present?

        context.booking_resource_skus = BookingResourceSku.left_joins(
          booking: [:product_sku]
        ).where(
          bookings: {
            aasm_state: :booked,
            product_skus: { handle: product_sku_handle }
          }
        )

        filter_by_ends_on

        preload_data

        context.data = generate_csv
      end

      private

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def generate_csv
        csv_headers = HEADERS.dup
        CSV.generate(headers: true) do |csv|
          csv << csv_headers

          context.booking_resource_skus.each do |booking_resource_sku|
            row_base = [
              booking_resource_sku.booking_id,
              booking_resource_sku.booking.aasm_state,
              nil,
              nil,
              booking_resource_sku.booking.season&.name,
              booking_resource_sku.booking.product&.name,
              booking_resource_sku.booking.product_sku&.name,
              booking_resource_sku.starts_on,
              booking_resource_sku.ends_on,
              booking_resource_sku.resource_snapshot["name"],
              booking_resource_sku.resource_sku_snapshot["name"],
              booking_resource_sku.resource_sku_snapshot["handle"],
              booking_resource_sku.price,
              booking_resource_sku.quantity,
              booking_resource_sku.total_price,
              booking_resource_sku.remarks,
              booking_resource_sku.booking_resource_sku_availability&.id,
              booking_resource_sku.availability&.inventory&.name
            ]

            rows = if booking_resource_sku.participants.any?
                     booking_resource_sku.participants.map do |participant|
                       new_row = row_base.dup
                       new_row[2] = participant.first_name
                       new_row[3] = participant.last_name
                       new_row
                     end
                   else
                     [row_base.dup]
                   end

            rows.each do |row|
              csv << row
            end
          end
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def filter_by_ends_on
        return if filter[:ends_on].blank?

        context.booking_resource_skus = context.booking_resource_skus
                                               .left_joins(:booking_attribute_values)
                                               .where("booking_attribute_values.handle = ?", :ends_on)
                                               .where("booking_attribute_values.value #{ends_on_operator} ?", parsed_ends_on_datetime)
      end

      def ends_on_operator
        operator = filter[:ends_on].fetch(:operator, "")

        return VALID_OPERATORS[operator.to_sym] if VALID_OPERATORS.key?(operator.to_sym)

        context.fail!(message: "invalid operator: supported operators are #{VALID_OPERATORS.keys}")
      end

      def parsed_ends_on_datetime
        DateTime.parse(filter[:ends_on].fetch(:value, ""))
      rescue ArgumentError
        context.fail!(message: "invalid datetime: datetime should be iso8601 conform (https://en.wikipedia.org/wiki/ISO_8601).")
      end

      def preload_data
        context.booking_resource_skus = context.booking_resource_skus.includes(
          :booking_attribute_values,
          :participants,
          booking: [
            :season,
            product: [:translations],
            product_sku: [:translations]
          ],
          availability: :inventory
        )
      end
    end
  end
end
