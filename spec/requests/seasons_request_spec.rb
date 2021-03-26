require 'rails_helper'

RSpec.describe "Seasons", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before do
    sign_in(user)
  end

  describe "new season" do
    before do
      get new_product_season_path(product, locale: I18n.locale)
    end

    it "renders the 'new' template" do
      expect(response).to render_template(:new)
    end

    it "renders the body with the correct title" do
      expect(response.body).to include(I18n.t("seasons.new.title"))
    end
  end

  describe "create season" do
    let(:season_params) do
      {
        name: "Season name",
        published_at: DateTime.new(2020,10,10,10,10,10)
      }
    end

    it "redirects the user to the product path" do
      post product_seasons_path(product, locale: I18n.locale, season: season_params)

      expect(response).to redirect_to(product_path(product))
    end

    it "adds a new season to the product" do
      expect {
        post product_seasons_path(product, locale: I18n.locale, season: season_params)
      }.to change { product.seasons.count }.by(1)
    end

    it "creates the season with the correct params" do
      post product_seasons_path(product, locale: I18n.locale, season: season_params)

      season = product.seasons.last

      expect(season.name).to eq("Season name")
      expect(season.published_at.to_s).to eq("2020-10-10 12:10:10 +0200")
    end

    context "when the season cannot get created" do
      let(:season_params) do
        { name: nil }
      end

      it "renders the new template" do
        post product_seasons_path(product, locale: I18n.locale, season: season_params)

        expect(response).to render_template(:new)
      end

      it "does not create a season" do
        expect {
          post product_seasons_path(product, locale: I18n.locale, season: season_params)
        }.not_to change { product.seasons.count }
      end

      it "shows the error message" do
        post product_seasons_path(product, locale: I18n.locale, season: season_params)

        expect(response.body).to include("<div class=\"Input-help Input--invalid\">#{Season.human_attribute_name(:name)} #{I18n.t('errors.messages.blank')}</div>")
      end
    end
  end

  describe "edit season" do
    let!(:season) { create(:season) }

    before do
      get edit_season_path(season, locale: I18n.locale)
    end

    it "renders the 'edit' template" do
      expect(response).to render_template(:edit)
    end

    it "renders the body with the correct title" do
      expect(response.body).to include(I18n.t("seasons.edit.title", name: season.name))
    end

    context "when the season is missing" do
      before do
        get edit_season_path("unknown", locale: I18n.locale)
      end

      it "renders the '404' template" do
        expect(response).to render_template("errors/404")
      end
    end
  end

  describe "update a season" do
    let!(:season) { create(:season, name: "unchanged") }

    let(:update_params) do
      {
        locale: I18n.locale,
        season: {
          name: "changed"
        }
      }
    end

    it "changes the season" do
      expect {
        patch season_path(season, update_params)
        season.reload
      }.to change { season.name }.from("unchanged").to("changed")
    end

    it "redirects the user to the product page" do
      patch season_path(season, update_params)

      expect(response).to redirect_to(product_path(season.product))
    end

    context "when the update fails" do
      let(:update_params) do
        {
          locale: I18n.locale,
          season: {
            name: nil
          }
        }
      end

      it "renders the edit view" do
        patch season_path(season, update_params)

        expect(response).to render_template("edit")
      end

      it "shows the error" do
        patch season_path(season, update_params)

        expect(response.body).to include("<div class=\"Input-help Input--invalid\">#{Season.human_attribute_name(:name)} #{I18n.t('errors.messages.blank')}</div>")
      end
    end
  end

  describe "remove a season" do
    let!(:season) { create(:season) }

    it "removes the season" do
      season_id = season.id

      delete season_path(season, locale: I18n.locale)

      expect(Season.find_by(id: season_id)).to be_blank
    end

    it "redirects to the product page" do
      delete season_path(season, locale: I18n.locale)

      expect(response).to redirect_to(product_path(season.product))
    end
  end
end
