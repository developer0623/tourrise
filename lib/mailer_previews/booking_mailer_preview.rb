# frozen_string_literal: true

class BookingMailerPreview < ActionMailer::Preview
  def created_mail
    BookingMailer.with(booking: Booking.in_progress.last).created_mail
  end
end
