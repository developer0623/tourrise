# frozen_string_literal: true

module Users
  class InviteUser
    include Interactor

    def call
      user = User.invite!(context.params, context.current_user)

      context.fail!(user: user, message: user.errors) unless user.invitation_sent_at.present?

      context.user = user
    end
  end
end
