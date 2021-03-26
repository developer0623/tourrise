# frozen_string_literal: true

module Users
  class LoadUser
    include Interactor

    def call
      user = User.without_system_users.find_by_id(context.user_id)

      unless user.present?
        context.fail!(
          message: I18n.t("errors.not_found", class: "User", id: context.user_id)
        )
      end

      context.user = user
    end
  end
end
