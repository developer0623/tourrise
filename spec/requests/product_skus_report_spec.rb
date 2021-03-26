require 'rails_helper'

RSpec.describe "product skus report", type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before do
    sign_in(user)
  end

  describe "reports overview" do
    before do
      product

      get reports_product_skus_path(locale: I18n.locale)
    end

    it "renders the 'index' template" do
      expect(response).to render_template(:index)
    end

    it "renders the body with the correct title" do
      expect(response.body).to include(I18n.t("reports.product_skus.index.title", count: 1))
    end
  end
end
