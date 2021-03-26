# frozen_string_literal: true

module Users
  class ListUsers
    include Interactor

    def call
      context.users = User.without_system_users
    end
  end
end
