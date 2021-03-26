# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Users::InviteUser, type: :interactor do
  describe '.call' do
    let(:current_user) { instance_double(User) }
    let(:user) { instance_double(User, invitation_sent_at: Time.zone.now) }
    let(:user_params) do
      { email: 'foo@bar.de' }
    end

    before do
      allow(User).to receive(:invite!) { user }
    end

    it 'has a success context' do
      context = described_class.call(params: user_params, current_user: current_user)

      expect(context).to be_a_success
    end

    it 'calls invite on the user' do
      described_class.call(params: user_params, current_user: current_user)
    end

    it 'sets the user context' do
      context = described_class.call(params: user_params, current_user: current_user)

      expect(context.user).to eq(user)
    end

    context 'with failure' do
      let(:user) { instance_double(User, invitation_sent_at: nil, errors: :error_message) }
      let(:user_params) { {} }

      it 'is a failure' do
        context = described_class.call(params: user_params, current_user: current_user)

        expect(context).to be_a_failure
      end

      it 'sets the user context' do
        context = described_class.call(params: user_params, current_user: current_user)

        expect(context.user).to eq(user)
      end

      it 'sets the message context' do
        context = described_class.call(params: user_params, current_user: current_user)

        expect(context.message).to eq(:error_message)
      end
    end
  end
end
