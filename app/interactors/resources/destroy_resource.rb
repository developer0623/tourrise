# frozen_string_literal: true

module Resources
  class DestroyResource
    include Interactor

    before do
      load_resource
    end

    def call
      context.fail!(message: context.resource.errors) unless context.resource.destroy
    end

    private

    def load_resource
      context.resource = Resource.find(context.resource_id)
    end
  end
end
