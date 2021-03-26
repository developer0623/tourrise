require 'rails_helper'

RSpec.describe Seasons::DeleteSeason, type: :interactor do
  describe '.call' do
    let(:season) { instance_double(Season) }

    before do
      allow(Seasons::LoadSeason).to receive(:call!) { season }
      allow(season).to receive(:destroy)
    end

    it 'loads the season' do
      context = described_class.call(season: season, season_id: 'season_id')

      expect(Seasons::LoadSeason).to have_received(:call!).with(context)
    end
    
    it 'is a success' do
      context = described_class.call(season: season, season_id: 'season_id')

      expect(context).to be_success
    end
    
    it 'has the season context' do
      context = described_class.call(season: season, season_id: 'season_id')

      expect(context.season).to eq(season)
    end

    it 'destroys the season' do
      described_class.call(season: season, season_id: 'season_id')

      expect(season).to have_received(:destroy).with(no_args)
    end
  end
end
