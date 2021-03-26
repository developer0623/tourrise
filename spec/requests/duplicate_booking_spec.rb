require "rails_helper"

RSpec.describe "Duplicate Booking", type: :request do
  let(:user) { FactoryBot.create(:user) }

  let(:booking) do
    FactoryBot.create(:booking) do |booking|
      booking.product_sku = product_sku
    end
  end

  let(:product) { FactoryBot.create(:product) }
  let(:product_sku) { product.product_skus.first }

  before do
    I18n.locale = :en
  end

  after do
    I18n.locale = I18n.default_locale
  end

  it "duplicates the current booking" do
    product_sku.save
    booking.save

    sign_in(user)

    get booking_path(booking, locale: I18n.locale)

    expect(response).to render_template(:show)

    expect {
      post duplicate_booking_url(booking, locale: I18n.locale)

      new_booking = Booking.find_by(duplicate_of_id: booking.id)

      expect(new_booking.secondary_state).to eq("offer_missing")
      expect(response).to redirect_to(edit_booking_url(new_booking, locale: I18n.locale))
      follow_redirect!
    }.to change { Booking.count }.by(1)

    expect(response).to render_template(:edit)
    expect(response.body).to include("Booking successfully duplicated")
  end
end
