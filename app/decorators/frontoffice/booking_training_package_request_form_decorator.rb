# frozen_string_literal: true

module Frontoffice
  class BookingTrainingPackageRequestFormDecorator < BookingFormDecorator
    def training_packages
      object.training_packages.map do |package|
        Frontoffice::ResourceDecorator.decorate(package)
      end
    end

    def current_step_handle
      :training_package_request
    end
  end
end
