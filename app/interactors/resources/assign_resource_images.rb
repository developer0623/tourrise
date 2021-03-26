# frozen_string_literal: true

module Resources
  class AssignResourceImages
    include Interactor

    def call
      context.fail!(message: "resource context missing") unless context.resource.present?

      attach_images
      remove_images
      assign_featured_image
    end

    private

    def attach_images
      return if context.images.blank?

      resource_image_service.add_images(context.images)
    end

    def remove_images
      return if context.remove_images.blank?

      resource_image_service.remove_images(context.remove_images)
    end

    def assign_featured_image
      return unless context.featured_image_id.present?

      context.resource.featured_image_id = context.featured_image_id
    end

    def resource_image_service
      @resource_image_service ||= ResourceImageService.new(context.resource)
    end
  end
end
