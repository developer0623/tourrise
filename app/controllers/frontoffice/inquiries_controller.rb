# frozen_string_literal: true

module Frontoffice
  class InquiriesController < FrontofficeController
    decorates_assigned :booking_form

    before_action :load_product_sku, only: %i[new create success]

    def new
      @booking_form = BookingInquiryForm.new(product_sku_id: params[:product_sku_id])
    end

    def create
      context = Inquiries::CreateInquiry.call(params: create_params, current_user: current_user)

      if context.success?
        redirect_to success_frontoffice_product_inquiries_path(product_sku_handle: params[:product_sku_handle])
      else
        @booking_form = BookingInquiryForm.new(create_params)
        @booking_form.valid?
        flash.now[:error] = context.message
        render "new", status: :unprocessable_entity
      end
    end

    def success; end

    private

    def create_params
      params.require(:booking).permit(
        %i[
          first_name
          last_name
          email
          starts_on
          ends_on
          adults
          kids
          babies
          wishyouwhat
        ]
      ).to_h.merge(
        product_sku_id: params[:product_sku_id]
      )
    end

    def load_product_sku
      context = ::Frontoffice::LoadProductSku.call(product_sku_handle: params[:product_sku_handle])

      render_not_found && return unless context.success?

      params[:product_sku_id] = context.product_sku.id
    end
  end
end
