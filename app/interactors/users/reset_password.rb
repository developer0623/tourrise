# frozen_string_literal: true

module Users
  class ResetPassword
    include Interactor

    def call
      user = User.reset_password_by_token(context.params)

      context.fail!(message: user.errors.full_messages.join(", ")) unless user.errors.blank?

      # Unlock interaction goes here in case the lockable module
      # is getting acitavted
      # e.g. UnlockUser.call(user_id: user.id)
      context.user = user
    end
  end
end
