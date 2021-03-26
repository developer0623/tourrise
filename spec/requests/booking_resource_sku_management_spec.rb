require 'rails_helper'

RSpec.describe 'Booking Resource Sku management', type: :request do
  let(:product) { FactoryBot.build(:product) }
  let(:product_sku) { FactoryBot.build(:product_sku) }
  let(:booking) { FactoryBot.create(:booking, product_sku: product_sku) }
  let(:user) { FactoryBot.create(:user) }

  before do
    product.product_skus << product_sku
    product.save

    I18n.locale = :en
  end

  after do
    I18n.locale = :de
  end

  it 'creates a BookingResourceSku and redirects to the booking page' do
    sign_in(user)

    get new_booking_booking_resource_sku_path(booking_id: booking.id, locale: :de)

    expect(response.body).to include(I18n.t('booking_resource_skus.new.title'))
  end
end
