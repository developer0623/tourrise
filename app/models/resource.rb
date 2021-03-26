# frozen_string_literal: true

class Resource < ApplicationRecord
  translates :name, :description, :teaser_text, fallbacks_for_empty_translations: true
  include GlobalizeScope

  has_many :taggables, as: :taggable
  has_many :tags, through: :taggables

  has_many_attached :images

  VALID_IMAGE_MIME_TYPES = %w[image/png image/jpg image/jpeg].freeze

  has_many :resource_skus, inverse_of: :resource, index_errors: true, dependent: :destroy
  accepts_nested_attributes_for :resource_skus, reject_if: :all_blank, allow_destroy: true

  has_many :product_resources, dependent: :destroy
  has_many :products, through: :product_resources

  belongs_to :resource_type

  validates :name, :resource_type_id, presence: true
  validates :images, blob: { content_type: VALID_IMAGE_MIME_TYPES }
  validates_associated :resource_skus
  validate :unique_resource_sku_handles

  scope :with_resource_type, ->(resource_type) { where(resource_type_id: resource_type.id) }

  def featured_image
    return if images.blank?

    images.find { |image| image.id == featured_image_id } || images.first
  end

  private

  def unique_resource_sku_handles
    resource_skus.group_by(&:handle).each do |_, group|
      next if group.count <= 1

      group.each do |resource_sku|
        resource_sku.errors.add(:handle, :taken)
      end
    end
  end
end
