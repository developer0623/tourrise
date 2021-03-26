# frozen_string_literal: true

class Api::V1::AuthenticateUser
  include Interactor

  def call
    context.user = User.find_for_authentication(email: context.email)

    context.fail!(message: "invalid credentials") unless context.user.present?
    context.fail!(message: "invalid credentials") unless context.user.valid_password?(context.password)
  end
end
