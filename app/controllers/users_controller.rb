# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :load_user, only: %i[show edit update]

  def index
    context = Users::ListUsers.call

    if context.success?
      @users = context.users.decorate
    else
      flash[:error] = "something went wrong"
      rendirect_to request.referer
    end
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    context = Users::InviteUser.call(params: user_params.to_h)
    @user = context.user

    if context.success?
      flash[:success] = I18n.t("users.create.success")
      redirect_to user_path(@user)
    else
      flash[:error] = context.message
      render "new", status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if password_change_request?
      update_with_password
    else
      update_without_password
    end
  end

  private

  def load_user
    context = Users::LoadUser.call(user_id: params[:id])

    if context.success?
      @user = context.user.decorate
    else
      render_not_found
    end
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def password_change_request?
    user_params[:password].present? && user_params[:password_confirmation].present?
  end

  def update_with_password
    if @user.update_with_password(user_params)
      bypass_sign_in @user
      flash["success"] = "Profil aktualisiert"
      redirect_to users_path
    else
      flash.now["error"] = "Profil konnte nicht aktualisiert werden: #{@user.errors.full_messages.to_sentence}"
      render "edit", status: :unprocessable_entity
    end
  end

  def update_without_password
    if @user.update_without_password(user_params.except(:current_password))
      flash["success"] = "Profil aktualisiert"
      redirect_to users_path
    else
      flash.now["error"] = "Profil konnte nicht aktualisiert werden: #{@user.errors.full_messages.to_sentence}"
      render "edit", status: :unprocessable_entity
    end
  end
end
