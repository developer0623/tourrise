# frozen_string_literal: true

module BookingResourceSkus
  class FindCreated
    include Interactor

    delegate :booking, :document_type, to: :context
    delegate :booking_resource_skus, to: :booking

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      context.created_booking_resource_skus = created_booking_resource_skus
    end

    private

    def created_booking_resource_skus
      all_booking_resource_skus.select do |booking_resource_sku|
        reference = last_reference_for(booking_resource_sku)

        reference.blank? && no_destroy_events?(booking_resource_sku)
      end
    end

    def no_destroy_events?(booking_resource_sku)
      !booking_resource_sku.versions.where(event: "destroy").exists?
    end

    def all_booking_resource_skus
      booking.booking_resource_skus.with_deleted.where(internal: false)
    end

    def last_reference_for(booking_resource_sku)
      booking_resource_sku.document_references.where(document_type: document_type).last
    end
  end
end
