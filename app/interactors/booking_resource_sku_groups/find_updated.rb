# frozen_string_literal: true

module BookingResourceSkuGroups
  class FindUpdated
    include Interactor

    KEY_ATTRIBUTES = %i[price_cents quantity].freeze

    delegate :booking, :document_type, to: :context
    delegate :booking_resource_sku_groups, to: :booking

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      context.updated_booking_resource_sku_groups = updated_booking_resource_sku_groups
    end

    private

    def updated_booking_resource_sku_groups
      all_booking_resource_sku_groups.select do |booking_resource_sku_group|
        reference = last_reference_for(booking_resource_sku_group)

        next false if reference.blank?

        no_removed_actions?(booking_resource_sku_group, reference) && key_attributes_updated?(booking_resource_sku_group, reference)
      end
    end

    def key_attributes_updated?(booking_resource_sku_group, reference)
      attributes_change_clause = KEY_ATTRIBUTES.map { |a| "object_changes LIKE '%#{a}:%'" }.join(" OR ")

      versions_after_reference_version(booking_resource_sku_group, reference)
        .where(attributes_change_clause)
        .where(event: "update")
        .exists?
    end

    def no_removed_actions?(booking_resource_sku_group, reference)
      !versions_after_reference_version(booking_resource_sku_group, reference).where(event: "destroy").exists?
    end

    def versions_after_reference_version(booking_resource_sku_group, reference)
      booking_resource_sku_group.versions.where("id > ?", reference.item_version_id)
    end

    def all_booking_resource_sku_groups
      booking.booking_resource_sku_groups.with_deleted
    end

    def last_reference_for(booking_resource_sku_group)
      booking_resource_sku_group.document_references.where(document_type: document_type).last
    end
  end
end
