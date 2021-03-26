# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SendResetPasswordInstructions, type: :interactor do
  subject(:context) { described_class.call(params: user_params) }

  let(:user_params) { { email: 'foo@bar.de' } }

  describe '.call' do
    context 'with success' do
      let(:user) do
        instance_double('User', errors: nil)
      end

      before do
        allow(User).to receive(:send_reset_password_instructions)
          .with(user_params)
          .and_return(user)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end
    end

    context 'with invalid unkown email address' do
      let(:user) do
        instance_double('User', errors: ['some error message'])
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
