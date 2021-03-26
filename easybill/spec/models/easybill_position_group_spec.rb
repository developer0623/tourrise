# frozen_string_literal: true

require 'rails_helper'

describe Easybill::PositionGroup do
  subject { Easybill::PositionGroup.new }

  context 'validations' do
    it { is_expected.to validate_presence_of(:resource_id) }
    it { is_expected.to validate_presence_of(:external_id) }
  end

  context 'associations' do
    it { is_expected.to have_many(:positions) }
    it { is_expected.to belong_to(:resource) }
  end
end

