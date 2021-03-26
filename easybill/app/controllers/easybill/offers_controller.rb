# frozen_string_literal: true

module Easybill
  class OffersController < ApplicationController
    def show
      context = DownloadOffer.call(offer_id: params[:id])

      return unless context.success?

      respond_to do |format|
        format.pdf do
          send_pdf_data(context.document, "Angebot.pdf")
        end
      end
    end
  end
end
