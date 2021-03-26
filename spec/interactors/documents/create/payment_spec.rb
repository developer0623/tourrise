require 'rails_helper'

RSpec.describe Documents::Create::Payment, type: :interactor do
  describe '.call' do
    let(:booking) { instance_double(Booking, starts_on: Date.today) }
    let(:booking_invoice) { instance_double(BookingInvoice, id: "booking_invoice_id", total_price: "total_price" ) }
    let(:payment) { instance_double(Payment) }

    before do
      allow(Payment).to receive(:new) { payment }
      allow(payment).to receive(:save) { true }
    end

    before do
      travel_to Date.new(2020,1,1)
    end

    after do
      travel_back
    end

    it "initializes a new payment object" do
      described_class.call(booking: booking, booking_invoice: booking_invoice)

      expect(Payment).to have_received(:new).with(
        booking_invoice_id: "booking_invoice_id",
        price: "total_price",
        due_on: Date.today
      )
    end

    context "when the booking is far in the future" do
      let(:booking) { instance_double(Booking, starts_on: 4.months.from_now.to_date) }

      it 'sets a due on date 30 days before the trip start' do
        described_class.call(booking: booking, booking_invoice: booking_invoice)

        expect(Payment).to have_received(:new).with(
          booking_invoice_id: "booking_invoice_id",
          price: "total_price",
          due_on: (4.months.from_now - 30.days)
        )
      end
    end

    context "when the booking is very close to start (less than 14 days for example)" do
      let(:booking) { instance_double(Booking, starts_on: 2.days.from_now.to_date) }

      it 'sets the due date to today' do
        described_class.call(booking: booking, booking_invoice: booking_invoice)

        expect(Payment).to have_received(:new).with(
          booking_invoice_id: "booking_invoice_id",
          price: "total_price",
          due_on: Date.today
        )
      end
    end

    context "when the booking starts in 15 days" do
      let(:booking) { instance_double(Booking, starts_on: 15.days.from_now.to_date) }

      it 'sets the due date to 14 days' do
        described_class.call(booking: booking, booking_invoice: booking_invoice)

        expect(Payment).to have_received(:new).with(
          booking_invoice_id: "booking_invoice_id",
          price: "total_price",
          due_on: 14.days.from_now
        )
      end
    end

    context "when the booking starts in 30 days" do
      let(:booking) { instance_double(Booking, starts_on: 30.days.from_now.to_date) }

      it 'sets the due date 30 days before the start' do
        described_class.call(booking: booking, booking_invoice: booking_invoice)

        expect(Payment).to have_received(:new).with(
          booking_invoice_id: "booking_invoice_id",
          price: "total_price",
          due_on: 14.days.from_now
        )
      end
    end

    context "when the payment cannot get saved" do
      before do
        allow(payment).to receive(:save) { false }
        allow(payment).to receive(:errors) { double(:errors, full_messages: "error_messages") }
      end

      it "sets an error message" do
        context = described_class.call(booking: booking, booking_invoice: booking_invoice)

        expect(context.message).to eq("error_messages")
      end
    end
  end
end
