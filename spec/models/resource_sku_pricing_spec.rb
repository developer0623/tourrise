require 'rails_helper'

RSpec.describe ResourceSkuPricing, type: :model do
  let(:calculation_types) { [:fixed, :per_person, :per_person_and_night, :consecutive_days] }
  let(:participant_types) { [:all_groups, :adult, :kid, :baby] }

  it { is_expected.to belong_to(:resource_sku) }

  it { is_expected.to validate_presence_of(:price_cents) }
  it { is_expected.to define_enum_for(:calculation_type).with_values(calculation_types) }
  it { is_expected.to define_enum_for(:participant_type).with_values(participant_types) }
end
