# frozen_string_literal: true

module Easybill
  class ApiController < ApplicationController
    include Api::Localizable

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error

    private

    def record_not_found_error(error = "record not found")
      render(
        json: { type: "not_found", code: 404, message: error.message },
        status: :not_found
      )
    end
  end
end
