# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ResetPassword, type: :interactor do
  subject(:context) { described_class.call(params: reset_params) }

  let(:reset_params) do
    {
      password: 'foobar',
      password_confirmation: 'foobar',
      reset_password_token: 'asdf'
    }
  end

  describe '.call' do
    context 'with success' do
      let(:user) do
        instance_double('User', errors: nil)
      end

      before do
        allow(User).to receive(:reset_password_by_token)
          .with(reset_params)
          .and_return(user)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the user' do
        expect(context.user).to eq(user)
      end
    end

    context 'with failure' do
      let(:user) do
        instance_double('User', errors: ['some error'])
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
