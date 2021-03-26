# frozen_string_literal: true

module Users
  class SendResetPasswordInstructions
    include Interactor

    def call
      user = User.send_reset_password_instructions(context.params)

      context.fail!(message: user.errors.full_messages.join(", ")) unless user.errors.blank?
    end
  end
end
