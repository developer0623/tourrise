# frozen_string_literal: true

module Frontoffice
  class BookingParticipantForm < BookingFormBase
    FORM_FIELDS = %w[participants_attributes].freeze

    attr_accessor(*FORM_FIELDS)

    validates :participants_attributes, presence: true
    validate :each_participant_valid?

    delegate :participants, to: :booking

    private

    def each_participant_valid?
      return unless participants_attributes.present?

      all_valid = participants_attributes.all? do |_, participant_data|
        ParticipantValidator.new(participant_data).valid?
      end

      errors.add(:participants, I18n.t("booking_form.errors.participants_data_incomplete")) unless all_valid
    end
  end
end
