# frozen_string_literal: true

module ResourceSkus
  class UpdateResourceSku
    include Interactor::Organizer

    before :setup_context
    before :setup_image_context

    organize LoadResourceSku, AssignResourceSkuAttributes, AssignResourceSkuTags, SaveResourceSku, AssignResourceSkuImage, PublishResourceSkuUpdatedEvent

    private

    def setup_context
      context.destroy_on_rollback = false
    end

    def setup_image_context
      context.image = context.params.delete(:images)&.last
      context.featured_image_id = context.params.delete(:featured_image_id)
      context.remove_images = context.params.delete(:remove_images)
    end
  end
end
