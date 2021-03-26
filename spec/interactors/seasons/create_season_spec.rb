require 'rails_helper'

RSpec.describe Seasons::CreateSeason, type: :interactor do
  describe '.call' do
    let(:product) { instance_double(Product) }
    let(:season) { instance_double(Season) }
    let(:season_params) do
      {
        name: "season_name",
        published_at: "1.1.2020"
      }.stringify_keys
    end

    before do
      allow(Products::LoadProduct).to receive(:call!) { true }
      allow(Season).to receive(:new) { season }
      allow(season).to receive(:save) { true }
    end

    it 'loads the product' do
      context = described_class.call(product_id: 'product_id', params: season_params)

      expect(Products::LoadProduct).to have_received(:call!).with(context)
    end

    it 'initializes a season with the correct attributes' do
      described_class.call(product_id: 'product_id', product: product, params: season_params)

      expect(Season).to have_received(:new).with(
        "name" => "season_name",
        "published_at" => "1.1.2020",
        "product" => product
      )
    end
    
    it 'is a success' do
      context = described_class.call(product_id: 'product_id', product: product, params: season_params)

      expect(context).to be_success
    end
    
    it 'has the season context' do
      context = described_class.call(product_id: 'product_id', product: product, params: season_params)

      expect(context.season).to eq(season)
    end

    context "when the season cannot get saved" do
      let(:season_errors) { double(:errors) }

      before do
        allow(season).to receive(:save) { false }
        allow(season).to receive(:errors) { season_errors }
        allow(season_errors).to receive(:full_messages) { "error_messages" }
      end

      it 'is a failure' do
        context = described_class.call(product_id: 'product_id', product: product, params: season_params)

        expect(context).to be_failure
      end

      it 'has a message context' do
        context = described_class.call(product_id: 'product_id', product: product, params: season_params)

        expect(context.message).to eq("error_messages")
      end
    end
  end
end
