require 'rails_helper'

RSpec.describe BookingDocumentsServiceBase, type: :service do
  class ExplicitDocumentsService < BookingDocumentsServiceBase
    private

    def document_type; end
  end

  let(:booking) { instance_double(Booking, unassigned?: false) }

  let(:booking_resource_skus_find_context) { double(:context, booking_resource_skus: booking_resource_skus) }
  let(:booking_resource_sku_groups_find_context) { double(:context, booking_resource_sku_groups: booking_resource_sku_groups) }
  let(:booking_credits_find_context) { double(:context, booking_credits: booking_credits) }

  let(:booking_resource_skus) { [] }
  let(:booking_resource_sku_groups) { [] }
  let(:booking_credits) { [] }

  let(:service) { ExplicitDocumentsService.new(booking) }

  before do
    allow(BookingResourceSkus::Find).to receive(:call) { booking_resource_skus_find_context }
    allow(BookingResourceSkuGroups::Find).to receive(:call) { booking_resource_sku_groups_find_context }
    allow(BookingCredits::Find).to receive(:call) { booking_credits_find_context }
  end

  describe '#document_creatable?' do
    context 'when everything is already documented' do
      it "is not creatable" do
        expect(service.document_creatable?).to be(false)
      end
    end

    context 'when something is not documented' do
      let(:booking_resource_skus) { ['one'] }

      it "is creatable" do
        expect(service.document_creatable?).to be(true)
      end
    end
  end

  describe '#document_available?' do
    context 'when everything is already documented' do
      it "is not creatable" do
        expect(service.document_available?).to be(true)
      end
    end

    context 'when something is not documented' do
      let(:booking_resource_skus) { ['one'] }

      it "is creatable" do
        expect(service.document_available?).to be(false)
      end
    end
  end
end
