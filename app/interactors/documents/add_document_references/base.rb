# frozen_string_literal: true

module Documents
  module AddDocumentReferences
    class Base
      include Interactor

      delegate :document, to: :context

      def call
        (collection || []).each do |item|
          price = price_info[item.id][:total_price]

          options = reference_options(item, action, price)

          add_document_reference(options)
        end
      end

      private

      def collection
        raise "Set collection value!"
      end

      def price_info
        raise "Set price_info value!"
      end

      def action
        raise "Set action value!"
      end

      def reference_options(item, event, price)
        {
          document: document,
          item: item,
          event: event,
          price: price
        }
      end

      def add_document_reference(options = {})
        Documents::AddDocumentReference.call(options)
      end
    end
  end
end
