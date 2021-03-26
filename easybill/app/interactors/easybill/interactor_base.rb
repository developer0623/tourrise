# frozen_string_literal: true

module Easybill
  class InteractorBase
    include Interactor

    private

    def easybill_api_service
      @easybill_api_service ||= ApiService.new
    end
  end
end
