# frozen_string_literal: true

module Tags
  class ListTags
    include Interactor

    def call
      context.tags = Tag.all
    end
  end
end
