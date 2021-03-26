# frozen_string_literal: true

class Customer < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_GENDER = %w[male female diverse].freeze

  has_paper_trail ignore: %i[created_at updated_at]

  has_many :bookings
  has_many :booking_participants
  has_many :participate_bookings, through: :booking_participants, source: :booking
  has_many :custom_attribute_values, as: :attributable, dependent: :destroy
  accepts_nested_attributes_for :custom_attribute_values, reject_if: :all_blank, allow_destroy: true
  has_many :custom_attributes, through: :custom_attribute_values
  has_many :booking_resource_sku_customers, dependent: :destroy
  has_many :booking_resource_skus, through: :booking_resource_sku_customers

  validates :first_name, :last_name, presence: true, unless: :placeholder?

  validates :email, presence: true, if: :contact_customer?
  validates_format_of :email, with: VALID_EMAIL_REGEX, if: :contact_customer?

  validate :country_is_iso_639, if: -> { country.present? }
  validates :gender, inclusion: { in: VALID_GENDER }, allow_blank: true

  validates :locale, inclusion: { in: PUBLIC_LOCALES.map(&:to_s) }, allow_blank: true
  validate :locale_is_iso_639, if: -> { locale.present? }

  enum participant_type: %i[adult kid baby]

  class << self
    alias adults adult
    alias kids kid
    alias babies baby
  end

  scope :only_contacts, -> { includes(:bookings).includes(booking_participants: :booking).where.not(bookings: { id: nil }).where.not(placeholder: true) }

  scope :with_bookings_count, lambda {
    select("customers.*, COUNT(bookings.id) AS bookings_count").left_joins(:bookings).group("customers.id")
  }

  scope :returning, lambda {
    only_contacts.with_bookings_count.select do |customer|
      customer.bookings_count > 1
    end
  }

  scope :happy_new, lambda {
    only_contacts.with_bookings_count.select do |customer|
      customer.bookings_count <= 1
    end
  }

  private

  def locale_is_iso_639
    iso639 = ISO_639.find(locale)
    errors.add(:locale, "Has to be iso639-2 format") unless iso639 && iso639.alpha2 == locale.downcase.to_s
  end

  def country_is_iso_639
    iso3166 = ISO3166::Country.new(country)

    return if iso3166 && iso3166.alpha2 == country.upcase

    errors.add(:country, I18n.t("booking_form.errors.invalid_country_code"))
  end

  def contact_customer?
    bookings.any?
  end
end
