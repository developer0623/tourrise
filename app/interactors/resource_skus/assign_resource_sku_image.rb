# frozen_string_literal: true

module ResourceSkus
  class AssignResourceSkuImage
    include Interactor

    def call
      context.fail!(message: "resource sku context missing") unless context.resource_sku.present?

      attach_images
      remove_images
    end

    private

    def attach_images
      return unless context.image.present?

      context.resource_sku.update_attribute(:images, [context.image])
    end

    def remove_images
      return if context.remove_images.blank?

      context.resource_sku.images.where(id: context.remove_images).purge
    end
  end
end
