# frozen_string_literal: true

module Cancellations
  class Create
    include Interactor

    delegate :user_id,
             :cancellable_type,
             :cancellable_id,
             :cancellation_reason_id,
             to: :context

    CANCELLABLE_TYPES = %w[BookingResourceSku BookingResourceSkuGroup BookingCredit].freeze

    def call
      context.fail!(message: wrong_type_message) unless CANCELLABLE_TYPES.include?(cancellable_type)

      cancellable_class.call(cancellable_params)
    end

    private

    def cancellable_class
      (cancellable_type.pluralize + "::Cancel").constantize
    end

    def cancellable_params
      {
        user_id: user_id,
        cancellable_type: cancellable_type,
        cancellable_id: cancellable_id,
        cancellation_reason_id: cancellation_reason_id
      }
    end

    def wrong_type_message
      I18n.t("interactor_errors.incorrect", attribute: :cancellable_type)
    end
  end
end
