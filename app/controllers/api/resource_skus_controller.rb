# frozen_string_literal: true

module Api
  class ResourceSkusController < ApiController
    def index
      context = Bookings::ListResourceSkus.call(list_params)

      if context.success?
        render json: context.resource_skus, root: :collection
      else
        render json: { error: context.message }, status: 400
      end
    end
  end
end
