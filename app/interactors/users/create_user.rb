# frozen_string_literal: true

module Users
  class CreateUser
    include Interactor

    def call
      context.user = User.new(context.params)

      context.fail!(message: context.user.errors.full_messages) unless context.user.save
    end
  end
end
