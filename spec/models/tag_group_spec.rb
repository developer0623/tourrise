require 'rails_helper'

RSpec.describe TagGroup, type: :model do
  it { is_expected.to have_many(:tags) }

  it { is_expected.to validate_presence_of(:name) }
end
