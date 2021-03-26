# frozen_string_literal: true

class GlobalConfiguration < ApplicationRecord
  validate :there_can_only_be_one, on: :create

  DEFAULT_COMPANY_NAME = "tourrise"

  def self.company_name
    return DEFAULT_COMPANY_NAME if all.blank?

    all.first.company_name
  end

  def self.company_name=(value)
    configuration = first_or_initialize
    configuration.update_attribute(:company_name, value)
  end

  def self.contact_phone
    return "" if all.blank?

    all.first.contact_phone
  end

  def self.contact_phone=(value)
    configuration = first_or_initialize
    configuration.update_attribute(:contact_phone, value)
  end

  def self.contact_email
    return "" if all.blank?

    all.first.contact_email
  end

  def self.contact_email=(value)
    configuration = first_or_initialize
    configuration.update_attribute(:contact_email, value)
  end

  def self.partial_payment_percentage
    return new.partial_payment_percentage if all.blank?

    all.first.partial_payment_percentage
  end

  def self.term_of_first_payment
    return new.term_of_first_payment if all.blank?

    all.first.term_of_first_payment
  end

  def self.term_of_final_payment
    return new.term_of_final_payment if all.blank?

    all.first.term_of_final_payment
  end

  private

  def there_can_only_be_one
    errors.add(:base, "There can only be one") if GlobalConfiguration.all.count.positive?
  end
end
