# frozen_string_literal: true

module Seasons
  class DeleteSeason
    include Interactor

    before do
      LoadSeason.call!(context)
    end

    def call
      context.season.destroy
    end
  end
end
