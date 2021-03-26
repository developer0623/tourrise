# frozen_string_literal: true

class BookingOfferDecorator < BookingDocumentDecorator
  def accepted?
    accepted_at.present?
  end

  def accepted_information
    return "-" unless accepted?

    h.content_tag("div") do
      h.t("date.ago_with_distance", time_ago_in_words: h.distance_of_time_in_words(Time.zone.now, accepted_at))
    end
  end

  def rejected?
    rejected_at.present?
  end

  def rejected_information
    return "-" unless rejected?

    h.content_tag("div") do
      h.t("date.ago_with_distance", time_ago_in_words: h.distance_of_time_in_words(Time.zone.now, rejected_at))
    end
  end

  private

  def easybill_document
    ::Easybill::Offer.find_by(booking_offer: object)
  end
end
