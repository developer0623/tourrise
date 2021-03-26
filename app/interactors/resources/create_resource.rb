# frozen_string_literal: true

module Resources
  class CreateResource
    include Interactor::Organizer

    before :setup_context
    before :setup_image_context

    organize AssignResourceAttributes, AssignResourceTags, AssignResourceImages, SaveResource, PublishResourceCreatedEvents

    private

    def setup_context
      context.resource = Resource.new
      context.destroy_on_rollback = true
    end

    def setup_image_context
      context.images = context.params.delete(:images)
      context.featured_image_id = context.params.delete(:featured_image_id)
    end
  end
end
