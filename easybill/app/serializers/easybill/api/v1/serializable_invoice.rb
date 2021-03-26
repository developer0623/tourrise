# frozen_string_literal: true

module Easybill
  module Api
    module V1
      class SerializableInvoice < JSONAPI::Serializable::Resource
        type "easybill_invoices"

        attributes :booking_invoice_id, :external_id, :created_at, :updated_at

        attribute :document do
          Easybill::ApiService.new.find_document(@object.external_id)
        rescue Easybill::Errors::ResourceNotFoundError
          :not_found
        end
      end
    end
  end
end
