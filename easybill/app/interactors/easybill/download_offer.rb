# frozen_string_literal: true

module Easybill
  class DownloadOffer
    include Interactor

    def call
      load_offer

      document = download_document

      context.document = document
    end

    private

    def load_offer
      offer = Offer.find_by(id: context.offer_id)
      context.fail!(message: :offer_not_found) unless offer.present?

      context.offer = offer
    end

    def download_document
      document = Easybill::ApiService.new.download_document(context.offer.external_id)

      context.fail!(offer: context.offer, message: :document_not_found) unless document.present?
      document
    end
  end
end
