# frozen_string_literal: true

module Products
  class LoadBookingParticipants
    include Interactor

    delegate :product, to: :context

    def call
      context.booking_participants = booking_participants
    end

    private

    def booking_participants
      BookingParticipant
        .joins(:participant, booking: [{ product_sku: [:translations, product: :translations] }, :customer])
        .where(
          product_sku_translations: { locale: I18n.locale },
          product_translations: { locale: I18n.locale },
          products: { id: product.id },
          bookings: { aasm_state: :booked, product_sku_id: product_sku_ids }
        )
        .select("
            booking_customers.*,
            bookings.customer_id AS customer_id,
            CONCAT_WS(' ', customers_bookings.first_name, customers_bookings.last_name) AS customer_name,
            customers_bookings.primary_phone AS customer_phone,
            customers_bookings.email AS customer_email,
            booking_customers.customer_id as participant_id,
            CONCAT_WS(' ', customers.first_name, customers.last_name) AS participant_name,
            customers.birthdate as participant_birthdate,
            customers.email as participant_email,
            product_sku_translations.name AS product_sku_name,
            product_translations.name AS product_name,
            bookings.starts_on as booking_starts_on,
            bookings.ends_on as booking_ends_on,
            CONCAT_WS(' - ', bookings.starts_on, bookings.ends_on) as booking_date_range
          ")
        .order("#{sort_column} #{sort_dir}")
        .page(context.page)
    end

    def product_sku_ids
      context.filter.fetch(:product_sku_id, product.product_skus.pluck(:id))
    end

    def sort_column
      context.sort_by || "id"
    end

    def sort_dir
      context.sort_dir || "ASC"
    end
  end
end
