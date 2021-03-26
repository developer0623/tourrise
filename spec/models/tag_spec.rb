require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should have_many(:taggables) }
  it { should have_many(:translations) }
end
