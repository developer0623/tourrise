# frozen_string_literal: true

class BookingMailer < ApplicationMailer
  def created_mail
    return Rails.logger.warn("Mailer configuration not complete") unless MailerConfiguration.first&.complete?

    @booking = params[:booking]

    customer_name = "#{@booking.first_name} #{@booking.last_name}"

    subject = default_i18n_subject(handle: @booking.product_sku.handle, name: customer_name)

    mail(
      from: MailerConfiguration.sender,
      to: MailerConfiguration.frontoffice_inbox,
      subject: subject,
      &:mjml
    )
  end
end
