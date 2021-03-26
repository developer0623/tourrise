# frozen_string_literal: true

module Easybill
  module Api
    module V1
      class OffersController < Api::V1Controller
        def show
          context = LoadOffer.call(booking_offer_id: params[:booking_offer_id])

          if context.success?
            render index_context_as_json(context)
          else
            render json: { errorr: context.message }, status: :bad_request
          end
        end

        private

        def index_context_as_json(context)
          {
            jsonapi: context.offer,
            class: {
              'Easybill::Offer': Api::V1::SerializableOffer
            }
          }
        end
      end
    end
  end
end
