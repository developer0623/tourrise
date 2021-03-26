# frozen_string_literal: true

module Resources
  class UpdateResource
    include Interactor::Organizer

    before :setup_context
    before :setup_image_context

    organize LoadResource, AssignResourceAttributes, AssignResourceTags, AssignResourceImages, SaveResource, PublishResourceUpdatedEvents

    private

    def setup_context
      context.destroy_on_rollback = false
    end

    def setup_image_context
      context.images = context.params.delete(:images)
      context.featured_image_id = context.params.delete(:featured_image_id)
      context.remove_images = context.params.delete(:remove_images)
    end
  end
end
