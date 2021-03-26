# frozen_string_literal: true

module Easybill
  module Api
    module V1
      class AuthenticateUser
        include Interactor

        def call
          context.user = User.find_for_authentication(email: context.email)

          fail_with_invalid_credentials unless context.user.present?
          fail_with_invalid_credentials unless context.user.valid_password?(context.password)
        end

        private

        def fail_with_invalid_credentials
          context.fail!(message: "invalid credentials")
        end
      end
    end
  end
end
