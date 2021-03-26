# frozen_string_literal: true

module BookingResourceSkuGroups
  class FindCanceled
    include Interactor

    delegate :booking, :document_type, to: :context
    delegate :booking_resource_sku_groups, to: :booking

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      context.canceled_booking_resource_sku_groups = canceled_booking_resource_sku_groups
    end

    private

    def canceled_booking_resource_sku_groups
      booking_resource_sku_groups.with_deleted.select do |booking_resource_sku_group|
        reference = last_reference_for(booking_resource_sku_group)

        next false if reference.blank?

        canceled_versions_higher_than_invoiced_exist?(booking_resource_sku_group, reference)
      end
    end

    def last_reference_for(booking_resource_sku_group)
      booking_resource_sku_group.document_references.where(document_type: document_type).last
    end

    def canceled_versions_higher_than_invoiced_exist?(booking_resource_sku_group, reference)
      booking_resource_sku_group.versions.where("id > ?", reference.item_version_id).where(event: "cancel").exists?
    end
  end
end
