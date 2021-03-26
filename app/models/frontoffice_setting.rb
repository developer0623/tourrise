# frozen_string_literal: true

class FrontofficeSetting < ApplicationRecord
  translates  :external_terms_of_service_url,
              :external_privacy_policy_url,
              fallbacks_for_empty_translations: true
  include GlobalizeScope

  validate :there_can_only_be_one, on: :create

  def self.company_name
    return unless any?

    last.company_name
  end

  def self.address_line_1
    return unless any?

    last.address_line_1
  end

  def self.address_line_2
    return unless any?

    last.address_line_2
  end

  def self.zip_code
    return unless any?

    last.zip_code
  end

  def self.city
    return unless any?

    last.city
  end

  def self.state
    return unless any?

    last.state
  end

  def self.country
    return unless any?

    last.country
  end

  def self.phone
    return unless any?

    last.phone
  end

  def self.email
    return unless any?

    last.email
  end

  def self.vat_id
    return unless any?

    last.vat_id
  end

  def self.external_terms_of_service_url
    return unless any?

    last.external_terms_of_service_url
  end

  def self.external_privacy_policy_url
    return unless any?

    last.external_privacy_policy_url
  end

  private

  def there_can_only_be_one
    errors.add(:base, "There can only be one") if self.class.any?
  end
end
