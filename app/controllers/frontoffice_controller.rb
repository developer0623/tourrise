# frozen_string_literal: true

class FrontofficeController < ApplicationController
  layout "frontoffice"

  after_action :allow_iframe
  before_action :current_client
  skip_before_action :authenticate_user!
  before_action :enhance_error_context

  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  KNOWN_THEMES = %w[hht allgaeutri].freeze

  private

  def current_user
    @current_user ||= FrontofficeUser
  end

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end

  def current_client
    return @current_client if defined?(@current_client)

    return unless params[:client].present? && update_current_client

    @current_client = params[:client] || session[:current_client]
    @current_client
  end

  def update_current_client
    return unless KNOWN_THEMES.include?(params[:client])

    session[:current_client] = params[:client]
  end

  def redirect_to_referer_or_path
    flash[:notice] = "Deine Sitzung ist abgelaufen. Bitte schicke deine Anfrage erneut ab."
    redirect_to request.referer
  end

  def render_not_found
    if @product_sku.present?
      flash[:error] = "Die Buchungsanfrage konnte nicht gefunden werden"
      redirect_to new_frontoffice_product_booking_path(@product_sku.handle, status: :not_found)
    else
      render "frontoffice/errors/404", status: :not_found
    end
  end

  def enhance_error_context
    Honeybadger.context(
      client: current_client,
      product_sku: @product_sku&.handle,
      office: :frontoffice
    )
  end
end
