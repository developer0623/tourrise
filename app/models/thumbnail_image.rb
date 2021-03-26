# frozen_string_literal: true

class ThumbnailImage
  SIZE = "64x64^"

  attr_reader :image

  def self.load(image)
    new(image).process
  end

  def initialize(image)
    @image = image
  end

  def process
    image.variant(crop: crop_options, resize: SIZE)
  end

  private

  def width
    image.metadata[:width]
  end

  def height
    image.metadata[:height]
  end

  def crop_options
    "#{width}x#{width}+0+0"
  end
end
