# frozen_string_literal: true

class MailerConfiguration < ApplicationRecord
  validate :there_can_only_be_one, on: :create

  DEFAULT_EMAIL_SENDER = "frontoffice@wavebooking.com"

  def self.sender
    return DEFAULT_EMAIL_SENDER if all.blank?

    all.first.sender
  end

  def self.sender=(value)
    configuration = first_or_initialize
    configuration.update_attribute(:sender, value)
  end

  def self.frontoffice_inbox
    return if all.blank?

    all.first.frontoffice_inbox
  end

  def self.frontoffice_inbox=(value)
    configuration = first_or_initialize
    configuration.update_attribute(:frontoffice_inbox, value)
  end

  def complete?
    frontoffice_inbox.present? && sender.present?
  end

  private

  def there_can_only_be_one
    errors.add(:base, "There can only be one") if MailerConfiguration.all.count.positive?
  end
end
