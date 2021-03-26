# frozen_string_literal: true

module Easybill
  class ResourceMapper
    class << self
      def to_easybill_position_group(resource)
        {
          name: resource.name,
          description: resource.description,
          number: resource.name.parameterize
        }
      end
    end
  end
end
