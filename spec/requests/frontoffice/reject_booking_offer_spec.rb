require "rails_helper"

RSpec.describe "Reject Booking Offer", type: :request do
  let(:user) { FactoryBot.create(:user) }

  let(:booking) { FactoryBot.create(:booking, :public) }
  let(:booking_offer) do
    FactoryBot.create(
      :booking_offer,
      :public,
      booking: booking,
      booking_snapshot: booking.attributes,
      booking_resource_skus_snapshot: [],
      booking_resource_sku_groups_snapshot: [],
      booking_credits_snapshot: [],
      customer_snapshot: booking.customer.attributes,
    )
  end

  before do
    I18n.locale = :en
  end

  after do
    I18n.locale = I18n.default_locale
  end

  it "sets the accepted_at time stamp" do
    sign_in(user)

    get frontoffice_booking_offer_path(booking_scrambled_id: booking_offer.booking.scrambled_id, scrambled_id: booking_offer.scrambled_id, locale: I18n.locale)

    expect(response).to render_template(:show)

    expect(response.body).to include(booking.title)
    expect(response.body).to include(I18n.t("booking_form.booking_offer.accept"))
    expect(response.body).to include(I18n.t("booking_form.booking_offer.reject"))

    expect {
      patch reject_frontoffice_booking_offer_path(scrambled_id: booking_offer.scrambled_id)

      expect(response).to redirect_to(frontoffice_booking_offer_path(booking_scrambled_id: booking_offer.booking.scrambled_id, scrambled_id: booking_offer.scrambled_id, locale: I18n.locale))
      follow_redirect!
      booking_offer.reload
    }.to change { booking_offer.rejected_at }

    expect(response.body).to include(booking.title)
    expect(response.body).to include("<div class='BookingDocument-badge rejected'>#{I18n.t('booking_form.booking_offer.rejected_badge')}</div>")
  end

  it "sets the secondary state of the booking to offer_rejected" do
    booking_offer.save

    patch reject_frontoffice_booking_offer_path(booking_scrambled_id: booking_offer.booking.scrambled_id, scrambled_id: booking_offer.scrambled_id, locale: I18n.locale)

    expect(booking_offer.booking.reload.secondary_state).to eq("offer_rejected")
  end
end
