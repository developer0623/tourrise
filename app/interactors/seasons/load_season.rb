# frozen_string_literal: true

module Seasons
  class LoadSeason
    include Interactor

    def call
      context.season = Season.find_by(id: context.season_id)

      context.fail!(message: :not_found) unless context.season.present?
    end
  end
end
