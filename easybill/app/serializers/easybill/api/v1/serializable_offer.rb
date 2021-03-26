# frozen_string_literal: true

module Easybill
  module Api
    module V1
      class SerializableOffer < JSONAPI::Serializable::Resource
        type "easybill_offers"

        attributes :booking_offer_id, :external_id, :created_at, :updated_at

        attribute :document do
          Easybill::ApiService.new.find_document(@object.external_id)
        end
      end
    end
  end
end
