# frozen_string_literal: true

module BookingCredits
  class FindCreated
    include Interactor

    delegate :booking, :document_type, to: :context
    delegate :booking_credits, to: :booking

    def call
      validate_context

      context.created_booking_credits = created_booking_credits
    end

    private

    def validate_context
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :document_type)) if document_type.blank?
    end

    def created_booking_credits
      all_booking_credits.select do |booking_credit|
        reference = last_reference_for(booking_credit)

        reference.blank? && no_destroy_events?(booking_credit)
      end
    end

    def no_destroy_events?(booking_credit)
      !booking_credit.versions.where(event: "destroy").exists?
    end

    def all_booking_credits
      booking.booking_credits.with_deleted
    end

    def last_reference_for(booking_credit)
      booking_credit.document_references.where(document_type: document_type).last
    end
  end
end
