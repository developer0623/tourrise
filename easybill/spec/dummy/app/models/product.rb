# frozen_string_literal: true

class Product < ApplicationRecord
  VALID_DOCUMENT_TYPES = %w[application/pdf].freeze

  translates :name, :description, fallbacks_for_empty_translations: true, touch: true
  include GlobalizeScope

  PUBLIC_LOCALES.each do |locale|
    has_one_attached "terms_of_service_#{locale}"
  end

  has_many :taggables, as: :taggable
  has_many :tags, through: :taggables

  has_many :seasons

  belongs_to :financial_account, optional: true
  belongs_to :cost_center, optional: true

  has_many :product_skus, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :product_skus,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes["name"].blank? && attributes["handle"].blank? }

  has_many :product_resources, dependent: :destroy
  has_many :resources, through: :product_resources
  has_many :bookings, through: :product_skus

  has_many :product_frontoffice_steps
  has_many :frontoffice_steps, through: :product_frontoffice_steps

  validates :name, :product_skus, presence: true
  validate :correct_terms_of_service_de_mime_type
  validate :mandatory_frontoffice_steps, if: :published?

  scope :published, -> { where.not(published_at: nil) }

  def publish
    update(published_at: Time.zone.now)
  end

  def published?
    published_at.present?
  end

  def terms_of_service
    public_send("terms_of_service_#{I18n.locale}")
  end

  private

  def correct_terms_of_service_de_mime_type
    return unless terms_of_service_de.attached?
    return if terms_of_service_de.content_type.in?(VALID_DOCUMENT_TYPES)

    self.terms_of_service_de = nil
    errors.add(:terms_of_service_de, "Must be a PDF")
  end

  def mandatory_frontoffice_steps
    return if (FrontofficeStep.mandatory.map(&:id) - frontoffice_step_ids).blank?

    errors.add(:frontoffice_steps, I18n.t("activerecord.errors.models.product.attributes.frontoffice_steps.mandatory_steps"))
  end
end
