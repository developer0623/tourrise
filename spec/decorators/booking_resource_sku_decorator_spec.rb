require 'rails_helper'

RSpec.describe BookingResourceSkuGroupDecorator do
  subject(:decorated_object) { booking_resource_sku.decorate }

  let(:booking_resource_sku) { create(:booking_resource_sku) }
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#removeable?' do
    subject { decorated_object.removeable? }

    describe 'true' do
      context 'sku is persisted' do
        it { is_expected.to be_truthy }
      end
    end

    describe 'false' do
      context 'current user is front office user' do
        let(:user) { FrontofficeUser.user }

        it { is_expected.to be_falsey }
      end

      context 'sku is not persisted' do
        let(:booking_resource_sku) { build(:booking_resource_sku) }

        it { is_expected.to be_falsey }
      end
    end
  end
end
