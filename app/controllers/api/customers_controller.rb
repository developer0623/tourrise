# frozen_string_literal: true

module Api
  class CustomersController < ApiController
    def show
      result = Customers::LoadCustomer.call(customer_id: params[:id])

      if result.success?
        render jsonapi: result.customer, fields: customer_fields
      else
        error = error_for(result)
        render json: { error: error }, status: error[:code]
      end
    end

    def index
      result = ::Customers::ListCustomers.call(filter: list_params)

      if result.success?
        render jsonapi: result.customers, fields: customer_fields
      else
        render json: { error: result.message }, status: 400
      end
    end

    private

    def customer_fields
      permitted_params = params.permit(:fields)
      return {} if permitted_params.fetch("fields", "").blank?

      {
        customers: permitted_params.fetch("fields").split(",")
      }
    end

    def error_for(result)
      case result.message
      when :not_found
        { code: 404, message: :not_found }
      else
        { code: 500, message: :api_error }
      end
    end
  end
end
