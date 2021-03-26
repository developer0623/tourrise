# frozen_string_literal: true

module BookingResourceSkus
  class FindCanceled
    include Interactor

    delegate :booking, :document_type, to: :context
    delegate :booking_resource_skus, to: :booking

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      context.canceled_booking_resource_skus = canceled_booking_resource_skus
    end

    private

    def canceled_booking_resource_skus
      booking_resource_skus.with_deleted.where(internal: false).select do |booking_resource_sku|
        reference = last_reference_for(booking_resource_sku)

        next false if reference.blank?

        canceled_versions_higher_than_invoiced_exist?(booking_resource_sku, reference)
      end
    end

    def last_reference_for(booking_resource_sku)
      booking_resource_sku.document_references.where(document_type: document_type).last
    end

    def canceled_versions_higher_than_invoiced_exist?(booking_resource_sku, reference)
      booking_resource_sku.versions.where("id > ?", reference.item_version_id).where(event: "cancel").exists?
    end
  end
end
