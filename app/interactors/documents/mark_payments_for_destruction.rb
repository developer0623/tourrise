# frozen_string_literal: true

module Documents
  class MarkPaymentsForDestruction
    include Interactor

    delegate :document, to: :context

    def call
      document.payments.each do |payment|
        next unless payment.price_cents.zero?

        payment.mark_for_destruction
      end
    end
  end
end
