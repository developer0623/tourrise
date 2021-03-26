# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingCredit, type: :model do
  it 'is referenceable' do
    expect(described_class.included_modules).to include(Referenceable)
  end
end