# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::LoadUser, type: :interactor do
  subject(:context) { described_class.call(user_id: user.id) }

  let(:user) { instance_double('User', id: 1) }

  describe '.call' do
    context 'existing contact' do
      before do
        allow(User).to receive(:find_by_id).with(user.id).and_return(user)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the user' do
        expect(context.user).to eq(user)
      end
    end

    context 'when the user doesn\'t exist' do
      before do
        allow(User).to receive(:find_by_id).with(user.id).and_return(nil)
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides a failure message' do
        expect(context.message).to be_present
      end
    end
  end
end
