# frozen_string_literal: true

module Settings
  class MesController < ApplicationController
    before_action :load_user

    def show; end

    def edit; end

    def update
      if user_params[:password].present?
        update_with_password
      else
        update_without_password
      end
    end

    private

    def load_user
      @me = User.find(current_user.id).decorate
    end

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :current_password,
        :password,
        :password_confirmation
      )
    end

    def update_with_password
      if @me.update_with_password(user_params)
        bypass_sign_in @me
        flash["success"] = "Profil aktualisiert"
        redirect_to settings_path
      else
        flash.now["error"] = "Profil konnte nicht aktualisiert werden: #{@me.errors.full_messages.to_sentence}"
        render "edit", status: :unprocessable_entity
      end
    end

    def update_without_password
      if @me.update(user_params.slice(:first_name, :last_name))
        flash["success"] = "Profil aktualisiert"
        redirect_to settings_path
      else
        flash.now["error"] = "Profil konnte nicht aktualisiert werden: #{@me.errors.full_messages.to_sentence}"
        render "edit", status: :unprocessable_entity
      end
    end
  end
end
