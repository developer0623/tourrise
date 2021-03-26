# frozen_string_literal: true

class CustomersController < ApplicationController
  PERMITTED_PARAMS = [
    :title,
    :gender,
    :company_name,
    :first_name,
    :last_name,
    :email,
    :address_line_1,
    :address_line_2,
    :zip,
    :city,
    :state,
    :country,
    :locale,
    :primary_phone,
    :secondary_phone,
    :birthdate,
    :general_customer_id,
    custom_attribute_values_attributes: {}
  ].freeze

  before_action :load_customer, only: %i[show edit]

  def index
    @customers = Customers::ListCustomers.call(page: params[:page], filter: filter_params, sort: sort_params).customers
    @customers = @customers.decorate
  end

  def show; end

  def new
    @customer = Customer.new
    @customer.custom_attribute_values.new(CustomAttribute.all.map { |custom_attribute| { custom_attribute: custom_attribute } })
    @customer = @customer.decorate
  end

  def edit; end

  def create
    context = Customers::CreateCustomer.call(params: customer_params.to_h)

    if context.success?
      flash[:success] = I18n.t("customers.create.success")
      redirect_to_success_path(context)
    else
      flash.now[:error] = context.message
      @customer = context.customer.decorate
      render "new", status: :unprocessable_entity
    end
  end

  def update
    context = Customers::UpdateCustomer.call(
      customer_id: params[:id],
      params: customer_params.to_h
    )

    handle_update(context)
  end

  private

  def redirect_to_success_path(context)
    if params[:redirect_to].present?
      redirect_to helpers.add_query_parameter_to_path(params[:redirect_to], customer_id: context.customer.id)
    else
      redirect_to customer_path(context.customer)
    end
  end

  def load_customer
    context = Customers::LoadCustomer.call(
      customer_id: params[:id]
    )

    render_not_found && return unless context.success?

    @customer = context.customer.decorate
  end

  def customer_params
    params.require(:customer).permit(PERMITTED_PARAMS)
  end

  def handle_update(context)
    if context.success?
      redirect_path = params[:booking_id].present? ? booking_path(params[:booking_id]) : customer_path(context.customer)
      redirect_to redirect_path
    else
      flash.now[:error] = context.message
      @customer = context.customer.decorate
      render "edit", status: :unprocessable_entity
    end
  end

  def filter_params
    { q: params[:q] }
  end
end
