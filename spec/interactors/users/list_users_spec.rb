# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ListUsers, type: :interactor do
  subject(:context) { described_class.call }

  let(:users) { [] }

  describe '.call' do
    before do
      allow(User).to receive(:without_system_users).with(no_args).and_return(users)
    end

    it 'succeeds' do
      expect(context).to be_a_success
    end

    it 'provides the users' do
      expect(context.users).to eq(users)
    end
  end
end
