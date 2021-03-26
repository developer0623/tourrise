# frozen_string_literal: true

module BookingResourceSkus
  class FindUpdated
    include Interactor

    KEY_ATTRIBUTES = %i[price_cents quantity].freeze

    delegate :booking, :document_type, to: :context
    delegate :booking_resource_skus, to: :booking

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      context.updated_booking_resource_skus = updated_booking_resource_skus
    end

    private

    def updated_booking_resource_skus
      all_booking_resource_skus.select do |booking_resource_sku|
        reference = last_reference_for(booking_resource_sku)

        next false if reference.blank?

        no_removed_actions?(booking_resource_sku, reference) && key_attributes_updated?(booking_resource_sku, reference)
      end
    end

    def key_attributes_updated?(booking_resource_sku, reference)
      attributes_change_clause = KEY_ATTRIBUTES.map { |a| "object_changes LIKE '%#{a}:%'" }.join(" OR ")

      versions_after_reference_version(booking_resource_sku, reference)
        .where(attributes_change_clause)
        .where(event: "update")
        .exists?
    end

    def no_removed_actions?(booking_resource_sku, reference)
      !versions_after_reference_version(booking_resource_sku, reference).where(event: "destroy").exists?
    end

    def versions_after_reference_version(booking_resource_sku, reference)
      booking_resource_sku.versions.where("id > ?", reference.item_version_id)
    end

    def all_booking_resource_skus
      booking.booking_resource_skus.with_deleted.where(internal: false)
    end

    def last_reference_for(booking_resource_sku)
      booking_resource_sku.document_references.where(document_type: document_type).last
    end
  end
end
