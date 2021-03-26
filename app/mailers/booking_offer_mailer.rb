# frozen_string_literal: true

class BookingOfferMailer < ActionMailer::Base
  def offer_state_changed_mail
    @booking_offer = params[:booking_offer]

    mail(
      from: MailerConfiguration.sender,
      to: @booking_offer.booking.assignee.email,
      subject: offer_state_changed_mail_subject
    )
  end

  private

  def offer_state_changed_mail_subject
    if @booking_offer.rejected_at.present?
      I18n.t("mailers.booking_offer.rejected", id: @booking_offer.id)
    elsif @booking_offer.accepted_at.present?
      I18n.t("mailers.booking_offer.accepted", id: @booking_offer.id)
    end
  end
end
