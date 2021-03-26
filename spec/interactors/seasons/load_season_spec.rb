require 'rails_helper'

RSpec.describe Seasons::LoadSeason, type: :interactor do
  describe '.call' do
    let(:season) { instance_double(Season) }

    before do
      allow(Season).to receive(:find_by) { season }
    end

    it 'finds the season' do
      context = described_class.call(season_id: 'season_id')

      expect(Season).to have_received(:find_by).with(id: 'season_id')
    end
    
    it 'is a success' do
      context = described_class.call(season_id: 'season_id')

      expect(context).to be_success
    end
    
    it 'has the season context' do
      context = described_class.call(season_id: 'season_id')

      expect(context.season).to eq(season)
    end

    context "when the season does not exist" do
      before do
        allow(Season).to receive(:find_by) { nil }
      end

      it 'is a failure' do
        context = described_class.call(season_id: 'season_id')

        expect(context).to be_failure
      end

      it 'has a message context' do
        context = described_class.call(season_id: 'season_id')

        expect(context.message).to eq(:not_found)
      end
    end
  end
end
