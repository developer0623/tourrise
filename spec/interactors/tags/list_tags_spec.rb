require 'rails_helper'

RSpec.describe Tags::ListTags, type: :interactor do
  subject(:context) { described_class.call }

  let(:tags) { [] }

  describe '.call' do
    before do
      allow(Tag).to receive(:all).with(no_args) { tags }
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the tags' do
      expect(context.tags).to eq(tags)
    end
  end
end