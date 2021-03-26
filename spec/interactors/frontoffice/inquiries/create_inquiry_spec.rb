require "rails_helper"

RSpec.describe Frontoffice::Inquiries::CreateInquiry, type: :interactor do
  describe "#call" do
    let(:params) do
      {
        first_name: "first_name",
        last_name: "last_name",
        email: "email",
        wishyouwhat: "somerandomtext",
        product_sku_id: "product_sku_id",
        starts_on: "starts_on",
        ends_on: "ends_on",
        adults: "adults",
        kids: "kids",
        babies: "babies"
      }.with_indifferent_access
    end

    let(:customer) { instance_double(Customer, id: 'customer_id', attributes: customer_attributes) }
    let(:customer_attributes) do
      {
        id: "customer_id",
        first_name: "first_name",
        last_name: "last_name",
        email: "email",
      }.with_indifferent_access
    end

    let(:booking) { instance_double(Booking, id: 'booking_id', participants: participants) }
    let(:participants) { [participant] }
    let(:participant) { instance_double(Customer) }

    let(:create_customer_context) { double(:create_customer_context, success?: true, customer: customer) }
    let(:create_booking_context) { double(:create_booking_context, success?: true, booking: booking) }

    before do
      allow(Customers::CreateCustomer).to receive(:call) { create_customer_context }
      allow(Bookings::CreateBooking).to receive(:call) { create_booking_context }

      allow(participant).to receive(:update) { true }
    end

    it "calls the create customer interactor" do
      described_class.call(params: params)

      expected_customer_params = {
        "first_name" => "first_name",
        "last_name" => "last_name",
        "email" => "email",
      }

      expect(Customers::CreateCustomer).to have_received(:call).with(params: expected_customer_params)
    end

    it "calls the create booking interactor" do
      described_class.call(params: params, current_user: 'current_user')

      expected_booking_params = {
        "wishyouwhat" => "somerandomtext",
        "product_sku_id" => "product_sku_id",
        "customer_id" => "customer_id",
        "starts_on" => "starts_on",
        "ends_on" => "ends_on",
        "adults" => "adults",
        "kids" => "kids",
        "babies" => "babies"
      }

      expect(Bookings::CreateBooking).to have_received(:call).with(params: expected_booking_params, current_user: 'current_user')
    end

    it "updates the first participant to be a clone of the current customer" do
      described_class.call(params: params)

      expected_participant_params = {
        "first_name" => "first_name",
        "last_name" => "last_name",
        "email" => "email",
      }

      expect(participant).to have_received(:update).with(expected_participant_params)
    end

    context "when the customer creation fails" do
      let(:create_customer_context) { double(:create_customer_context, success?: false, message: 'customer_error_message') }

      it "sets the failure context" do
        context = described_class.call(params: params)

        expect(context).to be_failure
      end

      it "sets an error message" do
        context = described_class.call(params: params)

        expect(context.message).to eq("customer_error_message")
      end
    end

    context "when the booking creation fails" do
      let(:create_booking_context) { double(:create_booking_context, success?: false, message: 'booking_error_message') }

      it "sets the failure context" do
        context = described_class.call(params: params)

        expect(context).to be_failure
      end

      it "sets an error message" do
        context = described_class.call(params: params)

        expect(context.message).to eq("booking_error_message")
      end
    end

    context "when the first participant cannot be updated" do
      before do
        allow(participant).to receive(:update) { false }
      end

      it "is still a success" do
        context = described_class.call(params: params)

        expect(context).to be_success
      end
    end
  end
end