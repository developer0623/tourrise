require 'rails_helper'

RSpec.describe Frontoffice::SendBookingCreatedMail, type: :interactor do
  let(:booking) { instance_double('Booking') }
  let(:booking_mailer) { instance_double('BookingMailer') }
  let(:mail) { double(:mail) }

  before do
    allow(BookingMailer).to receive(:with) { booking_mailer }
    allow(booking_mailer).to receive(:created_mail) { mail }
    allow(mail).to receive(:deliver_later)
  end

  describe '.call' do
    subject(:context) { described_class.call(booking: booking) }

    it { is_expected.to be_success }

    it 'sets the bookig mailer context' do
      subject

      expect(BookingMailer).to have_received(:with).with(booking: booking)
    end

    it 'creates the mail' do
      subject

      expect(booking_mailer).to have_received(:created_mail).with(no_args)
    end

    it 'delivers the mail in the background' do
      subject

      expect(mail).to have_received(:deliver_later).with(no_args)
    end
  end
end