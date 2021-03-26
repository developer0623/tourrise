# frozen_string_literal: true

class ResourceImageService
  def initialize(resource)
    @resource = resource
  end

  def add_images(images)
    if @resource.persisted?
      @resource.images.attach(images)
    else
      @resource.images = images
    end
  end

  def remove_images(image_ids)
    @resource.images.where(id: image_ids).purge

    clear_featured_image if image_ids.include?(@resource.featured_image_id)
  end

  private

  def clear_featured_image
    if @resource.persisted?
      @resource.update_attribute(:featured_image_id, nil)
    else
      @resource.featured_image_id = nil
    end
  end
end
