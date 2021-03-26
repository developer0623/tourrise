# frozen_string_literal: true

require 'rails_helper'

describe Easybill::Position do
  subject { Easybill::Position.new }

  context 'validations' do
    it { is_expected.to validate_presence_of(:resource_sku_id) }
    it { is_expected.to validate_presence_of(:external_id) }
  end
end
