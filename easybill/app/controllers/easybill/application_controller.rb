# frozen_string_literal: true

module Easybill
  class ApplicationController < ::ApplicationController
    layout "application"
    protect_from_forgery with: :exception

    private

    def send_pdf_data(data, filename)
      send_data(data, filename: filename, type: "application/pdf")
    end
  end
end
