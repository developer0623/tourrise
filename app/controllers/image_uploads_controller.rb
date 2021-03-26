# frozen_string_literal: true

class ImageUploadsController < ActiveStorage::DirectUploadsController
  VALID_CONTENT_TYPES = %w[image/png image/jpg image/jpeg].freeze

  def create
    if valid_content_type
      super
    else
      render json: { errors: ["invalid content type"] }, status: :unprocessable_entity
    end
  end

  private

  def valid_content_type
    return false if blob_args[:content_type].blank?
    return false unless VALID_CONTENT_TYPES.include?(blob_args[:content_type])

    true
  end
end
