require 'rails_helper'

RSpec.describe BookingInvoiceDecorator do
  subject(:decorated_invoice) { described_class.decorate(invoice) }

  let(:invoice) { instance_double(BookingInvoice, booking: booking, total_price: 50000) }
  let(:booking) { instance_double(Booking) }
  let(:canceled_booking_resource_skus) { [] }

  let(:removed_skus_finder_class) { BookingResourceSkus::FindCanceled }

  let(:removed_skus_finder) do
    double(:removed_skus_finder, success?: true, canceled_booking_resource_skus: canceled_booking_resource_skus)
  end

  before do
    allow(Payment).to receive(:new)

    allow(removed_skus_finder_class).to receive(:call).with(booking: booking) { removed_skus_finder }
  end

  describe "#initialize_partial_payment" do
    context "when all booking_resource_skus allow partial payment and booking is in 60 days" do
      before do
        allow(decorated_invoice).to receive_message_chain(:full_payment_booking_resource_skus, :any?) { false }
        allow(decorated_invoice).to receive_message_chain(:full_payment_booking_resource_skus, :sum) { 0 }
      end

      it "sets the configured percentage of the booking_resource_skus summed prices as price" do
        decorated_invoice.initialize_partial_payment

        expect(Payment).to have_received(:new).with(price: 10000, due_on: Time.zone.today + GlobalConfiguration.term_of_first_payment.days)
      end
    end

    context "when some booking_resource_skus do not allow partial payment" do
      before do
        allow(decorated_invoice).to receive_message_chain(:full_payment_booking_resource_skus, :any?) { true }
        allow(decorated_invoice).to receive_message_chain(:full_payment_booking_resource_skus, :sum) { 5000 }
      end

      it "calculates the price from partially and fully payed booking_resource_skus" do
        decorated_invoice.initialize_partial_payment

        expect(Payment).to have_received(:new).with(price: 14000, due_on: Time.zone.today + GlobalConfiguration.term_of_first_payment.days)
      end
    end
  end

  describe "#initialize_final_payment" do
    context "when invoice is payed in partial and final payment" do
      before do
        allow(booking).to receive(:starts_on) { Time.zone.today + 60.days }
        allow(decorated_invoice).to receive(:partially_payable?) { true }
        allow(decorated_invoice).to receive(:short_term_booking) { false }
      end

      context "when all booking_resource_skus allow partial payment" do
        before do
          allow(decorated_invoice).to receive(:partial_payment_price) { 10000 }
        end

        it "calculates the price and due date correctly" do
          decorated_invoice.initialize_final_payment

          expect(Payment).to have_received(:new).with(price: 40000, due_on: booking.starts_on - GlobalConfiguration.term_of_final_payment.days)
        end
      end

      context "when only some booking_resource_skus allow partial payment" do
        before do
          allow(decorated_invoice).to receive_message_chain(:full_payment_booking_resource_skus, :any?) { true }
          allow(decorated_invoice).to receive_message_chain(:full_payment_booking_resource_skus, :sum) { 5000 }
        end

        it "calculates the price and due date correctly" do
          decorated_invoice.initialize_final_payment

          expect(Payment).to have_received(:new).with(price: 36000, due_on: booking.starts_on - GlobalConfiguration.term_of_final_payment.days)
        end
      end
    end

    context "when invoice is payed in one payment" do
      before do
        allow(decorated_invoice).to receive_message_chain(:partial_payment_booking_resource_skus, :any?) { false }
        allow(decorated_invoice).to receive_message_chain(:undocumented_booking_resource_sku_groups, :any?) { false }
      end

      context "when booking starts 60 days from now" do
        before do
          allow(booking).to receive(:starts_on) { Time.zone.today + 20.days }
          allow(decorated_invoice).to receive(:short_term_booking) { false }
        end

        it "sets the bookings total price as payment price" do
          decorated_invoice.initialize_final_payment

          expect(Payment).to have_received(:new).with(price: 50000, due_on: Time.zone.today + GlobalConfiguration.term_of_first_payment.days)
        end
      end

      context "when booking starts 2 days from now" do
        before do
          allow(booking).to receive(:starts_on) { Time.zone.today + 2.days }
        end

        it "sets tomorrow as payment due date" do
          decorated_invoice.initialize_final_payment

          expect(Payment).to have_received(:new).with(price: 50000, due_on: Time.zone.tomorrow)
        end
      end
    end
  end
end
