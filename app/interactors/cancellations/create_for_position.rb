# frozen_string_literal: true

module Cancellations
  class CreateForPosition
    include Interactor

    delegate :user_id,
             :cancellable_type,
             :cancellable_id,
             :cancellation_reason_id,
             :cancellation,
             to: :context

    def call
      context.cancellation = Cancellation.new(params)

      context.fail!(message: cancellation.errors.full_messages) unless cancellation.save

      cancellation.cancellable.paper_trail_event = "cancel"
      cancellation.cancellable.paper_trail.save_with_version
    end

    private

    def params
      {
        user_id: user_id,
        cancellable_type: cancellable_type,
        cancellable_id: cancellable_id,
        cancellation_reason_id: cancellation_reason_id
      }
    end
  end
end
