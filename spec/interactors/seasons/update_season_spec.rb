require 'rails_helper'

RSpec.describe Seasons::UpdateSeason, type: :interactor do
  describe '.call' do
    let(:season) { instance_double(Season) }
    let(:season_params) do
      {
        name: "season_name",
        published_at: "1.1.2020"
      }.stringify_keys
    end

    before do
      allow(Seasons::LoadSeason).to receive(:call)
      allow(season).to receive(:update) { true }
    end

    it 'updates the season' do
      described_class.call(season: season, params: season_params)

      expect(season).to have_received(:update).with(
        "name" => "season_name",
        "published_at" => "1.1.2020"
      )
    end
    
    it 'is a success' do
      context = described_class.call(season: season, params: season_params)

      expect(context).to be_success
    end
    
    it 'has the season context' do
      context = described_class.call(season: season, params: season_params)

      expect(context.season).to eq(season)
    end

    context "when the season cannot be saved" do
      let(:season_errors) { double(:errors) }

      before do
        allow(season).to receive(:update) { false }
        allow(season).to receive(:errors) { season_errors }
        allow(season_errors).to receive(:full_messages) { "error_messages" }
      end

      it 'is a failure' do
        context = described_class.call(season: season, params: season_params)

        expect(context).to be_failure
      end

      it 'has a message context' do
        context = described_class.call(season: season, params: season_params)

        expect(context.message).to eq("error_messages")
      end
    end
  end
end
