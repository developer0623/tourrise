# frozen_string_literal: true

module Reports
  class ProductSkuReportDecorator < Draper::Decorator
    def product_name
      object.product.name
    end

    def product_sku_name
      object.name
    end

    Booking.aasm.states.map(&:name).each do |state|
      define_method("#{state}_bookings") do
        object.bookings.public_send(state)
      end
    end

    def season_names
      seasons.map do |season|
        if object.product.current_season&.name == season.name
          h.content_tag(:strong) do
            season.name
          end
        else
          season.name
        end
      end.join(", ")
    end

    def participants_count
      bookings.booked.joins(:participants).count
    end

    def participants_count_for_resource(resource)
      h.content_tag(:div) do
        resource.resource_skus.map do |resource_sku|
          h.content_tag(:div) do
            [
              resource_sku.name,
              bookings.booked.joins(booking_resource_skus: [:participants]).where(booking_resource_skus: { resource_sku_id: resource_sku.id }).count
            ].join(": ")
          end
        end.reduce(:+)
      end
    end

    private

    def seasons
      return object.seasons unless context[:season_ids].present?

      object.seasons.where(id: context[:season_ids])
    end

    def bookings
      return object.bookings unless context[:season_ids].present?

      object.bookings.where(season_id: context[:season_ids])
    end
  end
end
