# frozen_string_literal: true

module BookingResourceSkuGroups
  class FindCreated
    include Interactor

    delegate :booking, :document_type, to: :context
    delegate :booking_resource_sku_groups, to: :booking

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      context.created_booking_resource_sku_groups = created_booking_resource_sku_groups
    end

    private

    def created_booking_resource_sku_groups
      all_booking_resource_sku_groups.select do |booking_resource_sku_group|
        reference = last_reference_for(booking_resource_sku_group)

        reference.blank? && no_destroy_events?(booking_resource_sku_group)
      end
    end

    def no_destroy_events?(booking_resource_sku_group)
      !booking_resource_sku_group.versions.where(event: "destroy").exists?
    end

    def all_booking_resource_sku_groups
      booking.booking_resource_sku_groups.with_deleted
    end

    def last_reference_for(booking_resource_sku_group)
      booking_resource_sku_group.document_references.where(document_type: document_type).last
    end
  end
end
