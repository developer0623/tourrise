# frozen_string_literal: true

module Settings
  class OccupationConfigurationsController < ApplicationController
    def index
      @occupation_configurations = OccupationConfiguration.all
    end
  end
end
