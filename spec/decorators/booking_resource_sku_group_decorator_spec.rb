require 'rails_helper'

RSpec.describe BookingResourceSkuGroupDecorator do
  subject(:decorated) { booking_resource_sku_group.decorate }

  let(:booking_resource_sku_group) { create(:booking_resource_sku_group, booking: booking) }
  let(:booking) { create(:booking) }

  context "#available_booking_resource_skus" do
    subject { decorated.available_booking_resource_skus }

    let!(:another_booking_resource_sku_group) { create(:booking_resource_sku_group, booking: booking) }
    let!(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
    let!(:cancelled_booking_resource_sku) { create(:booking_resource_sku, :canceled, booking: booking) }
    let!(:grouped_booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
    let(:expected_result) { [booking_resource_sku] }

    before do
      another_booking_resource_sku_group.booking_resource_skus << grouped_booking_resource_sku
    end

    describe "return correct results" do
      it { is_expected.to eq(expected_result) }
    end
  end
end
