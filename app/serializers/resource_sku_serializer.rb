# frozen_string_literal: true

class ResourceSkuSerializer < JSONAPI::Serializable::Resource
  attributes :id,
             :name,
             :handle,
             :resource_name

  def resource_name
    object.resource.name
  end

  def helpers
    ActionController::Base.helpers
  end
end
