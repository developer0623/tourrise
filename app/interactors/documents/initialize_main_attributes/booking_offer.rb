# frozen_string_literal: true

module Documents
  module InitializeMainAttributes
    class BookingOffer < Base
      private

      def document_class
        ::BookingOffer
      end
    end
  end
end
