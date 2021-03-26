# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'digests the password input' do
    user = User.new(email: 'foo@example.com', password: 'changeme')
    expect(user.encrypted_password).to be
  end
end
