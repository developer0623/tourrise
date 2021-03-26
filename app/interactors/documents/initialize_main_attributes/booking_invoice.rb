# frozen_string_literal: true

module Documents
  module InitializeMainAttributes
    class BookingInvoice < Base
      before do
        context.params ||= {}
      end

      private

      def document_params
        super.merge(
          payments_attributes: params["payments_attributes"] || {},
          description: params["description"]
        )
      end

      def document_class
        ::BookingInvoice
      end
    end
  end
end
