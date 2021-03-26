# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cancellations::Create, type: :interactor do
  subject { described_class.call(interactor_params) }

  let(:interactor_params) do
    {
      user_id: "user_id",
      cancellable_type: cancellable_type,
      cancellable_id: "cancellable_id",
      cancellation_reason_id: "cancellation_reason_id"
    }
  end

  let(:cancellable_type) { "cancellable_type" }

  context "valid" do
    describe "correctly creates cancellation" do
      context "booking resource skus" do
        let(:cancellable_type) { "BookingResourceSku" }

        it { is_expected.to be_success }

        it do
          expect(BookingResourceSkus::Cancel).to receive(:call).with(interactor_params)

          subject
        end
      end

      context "booking resource groups" do
        let(:cancellable_type) { "BookingResourceSkuGroup" }

        it { is_expected.to be_success }

        it do
          expect(BookingResourceSkuGroups::Cancel).to receive(:call).with(interactor_params)

          subject
        end
      end

      context "credits" do
        let(:cancellable_type) { "BookingCredit" }

        it { is_expected.to be_success }

        it do
          expect(BookingCredits::Cancel).to receive(:call).with(interactor_params)

          subject
        end
      end
    end
  end

  context "invalid" do
    describe "booking is empty" do
      let(:cancellable_type) { nil }
      let(:expected_message) { I18n.t("interactor_errors.incorrect", attribute: :cancellable_type) }

      it { is_expected.to be_failure }
      it { expect(subject.message).to eq(expected_message) }
    end
  end
end
