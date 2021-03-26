# frozen_string_literal: true

module Frontoffice
  class SendBookingCreatedMail
    include Interactor

    def call
      BookingMailer.with(booking: context.booking).created_mail.deliver_later
    end
  end
end
