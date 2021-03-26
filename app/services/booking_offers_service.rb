# frozen_string_literal: true

class BookingOffersService < BookingDocumentsServiceBase
  alias offer_available? document_available?
  alias offer_creatable? document_creatable?

  private

  def document_type
    "BookingOffer"
  end
end
