require "rails_helper"

RSpec.describe "Accept Booking Offer", type: :request do
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

  describe "view the offer" do
    before do
      get frontoffice_booking_offer_path(booking_scrambled_id: booking_offer.booking.scrambled_id, scrambled_id: booking_offer.scrambled_id, locale: I18n.locale)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "renders the body with the title" do
      expect(response.body).to include(booking.title)
    end

    it "has the accept button visible on the page" do
      expect(response.body).to include(I18n.t("booking_form.booking_offer.accept"))
    end

    it "has the reject button visibile on the page" do
      expect(response.body).to include(I18n.t("booking_form.booking_offer.reject"))
    end

    context "when the booking has been accepted" do
      let(:booking_offer) do
        create(
          :booking_offer,
          :accepted,
          booking: booking,
          booking_snapshot: booking.attributes,
          booking_resource_skus_snapshot: [],
          booking_resource_sku_groups_snapshot: [],
          customer_snapshot: booking.customer.attributes,
          booking_credits_snapshot: []
        )
      end

      it "shows the accepted badge" do
        expect(response.body).to include("<div class='BookingDocument-badge accepted'>#{I18n.t('booking_form.booking_offer.accepted_badge')}</div>")
      end
    end
  end

  describe "when the user accepts the offer" do
    let(:accept_params) do
      {
        booking_scrambled_id: booking_offer.booking.scrambled_id,
        scrambled_id: booking_offer.scrambled_id,
        locale: I18n.locale,
        booking: booking_params
      }
    end

    let(:booking_params) do
      {
        terms_of_service_accepted: true,
        privacy_policy_accepted: true
      }
    end

    it "sets the accepted at timestamp" do
      patch accept_frontoffice_booking_offer_path(accept_params)

      booking_offer.reload

      expect(booking_offer.accepted_at).to be_present
    end

    it "sets the secondary state of the booking to invoice_missing" do
      patch accept_frontoffice_booking_offer_path(accept_params)

      expect(booking.reload.secondary_state).to eq("invoice_missing")
    end

    context "when the TOS have not been accepted" do
      let(:booking_params) do
        { terms_of_service_accepted: false, privacy_policy_accepted: true }
      end

      it "responds with an error message" do
        patch accept_frontoffice_booking_offer_path(accept_params)

        follow_redirect!

        expect(response.body).to include(I18n.t("booking_form.booking_offer.booking_tos_and_pp_not_accepted"))
      end
    end
  end
end
