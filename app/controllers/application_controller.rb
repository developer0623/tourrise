# frozen_string_literal: true

class ApplicationController < ActionController::Base
  default_form_builder ActionView::Helpers::WaveFormBuilder

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :enhance_error_context
  before_action :set_locale
  before_action :set_paper_trail_whodunnit

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def render_not_found
    render "errors/404", status: 404
  end

  def enhance_error_context
    return unless current_user.present?

    Honeybadger.context(
      user_id: current_user.id,
      user_email: current_user.email,
      user_name: "#{current_user.first_name} #{current_user.last_name}"
    )
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    PUBLIC_LOCALES.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def user_for_paper_trail
    user_signed_in? ? current_user.name : ""
  end

  def sort_params
    { by: params[:sort_by], order: params[:sort_order] }
  end

  def pagination_params
    { page: params[:page], per: params[:per] }
  end
end
