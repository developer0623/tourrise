# frozen_string_literal: true

require 'rails_helper'

class DummyItem < ApplicationRecord
  self.table_name = 'booking_resource_skus'

  include Referenceable
end

RSpec.describe Referenceable, type: :model do
  subject(:described_class) { DummyItem }

  context "instance methods" do
    subject { described_class.new }

    describe "associations" do
      it { is_expected.to have_many(:document_references) }
      it { is_expected.to have_many(:invoices) }
      it { is_expected.to have_many(:offers) }
    end
  end

  context "scopes" do
    let(:booking) { create(:booking) }
    let(:document) { create(:booking_invoice, booking: booking) }

    let(:created_booking_resource_skus) { [created_booking_resource_sku] }
    let(:created_booking_resource_sku) { create(:booking_resource_sku, booking: booking) }

    let!(:created_document_reference) do
      create(:document_reference, :added,
        item: created_booking_resource_sku,
        document: document,
        item_version_id: created_booking_resource_sku.versions.last.id
      )
    end

    let(:updated_booking_resource_skus) { [updated_booking_resource_sku] }
    let(:updated_booking_resource_sku) { create(:booking_resource_sku, booking: booking, price_cents: 50) }

    let(:canceled_booking_resource_skus) { [removed_booking_resource_sku] }
    let(:removed_booking_resource_sku) { create(:booking_resource_sku, booking: booking) }

    before do
      updated_booking_resource_sku.update(price_cents: 100)
      removed_booking_resource_sku.destroy

      create(:document_reference, :modified,
        item: updated_booking_resource_sku,
        document: document,
        item_version_id: updated_booking_resource_sku.versions.last.id
      )

      create(:document_reference, :canceled,
        item: removed_booking_resource_sku,
        document: document,
        item_version_id: removed_booking_resource_sku.versions.last.id
      )
    end

    describe "#created_by_document" do
      subject { described_class.created_by_document(document) }

      let(:expected_result) { created_booking_resource_skus }

      describe "get all dummy objects that were created within document" do
        it { is_expected.to match_array(expected_result) }
      end
    end

    describe "#updated_by_document" do
      subject { described_class.updated_by_document(document) }

      let(:expected_result) { updated_booking_resource_skus }

      describe "get all dummy objects that were updated within document" do
        it { is_expected.to match_array(expected_result) }
      end
    end

    describe "#removed_by_document" do
      subject { described_class.removed_by_document(document) }

      let(:expected_result) { canceled_booking_resource_skus }

      describe "get all dummy objects that were removed within document" do
        it { is_expected.to match_array(expected_result) }
      end
    end
  end
end
