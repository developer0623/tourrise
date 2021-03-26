# frozen_string_literal: true

module Easybill
  module Api
    class V1Controller < ApiController
      class NotAuthorizedError < StandardError; end

      rescue_from NotAuthorizedError, with: :deny_access

      before_action :authenticate_user!

      private

      def deny_access
        render json: { error: "invalid credentials" }
      end

      def authenticate_user!
        return true if user_signed_in?

        context = Api::V1::AuthenticateUser.call(
          warden: warden,
          email: request.headers["X-AUTH-EMAIL"],
          password: request.headers["X-AUTH-PASSWORD"]
        )

        raise NotAuthorizedError if context.failure?
      end

      def pagination_params
        {
          page: params[:page],
          limit: params[:limit]
        }
      end
    end
  end
end
