# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    layout "layouts/logged_out", only: %i[edit update]

    def after_invite_path_for(_inviter, _invitee)
      users_path
    end
  end
end
