# frozen_string_literal: true

module Easybill
  module Api
    module V1
      class InvoicesController < Api::V1Controller
        def show
          context = LoadInvoice.call(booking_invoice_id: params[:booking_invoice_id])

          if context.success?
            render index_context_as_json(context)
          else
            render json: { errorr: context.message }, status: :bad_request
          end
        end

        private

        def index_context_as_json(context)
          {
            jsonapi: context.invoice,
            class: {
              'Easybill::Invoice': Api::V1::SerializableInvoice
            }
          }
        end
      end
    end
  end
end
