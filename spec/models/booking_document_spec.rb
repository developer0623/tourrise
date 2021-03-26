# frozen_string_literal: true

require 'rails_helper'

class ExplicitDocument < BookingDocument
  self.table_name = 'booking_offers'
end

RSpec.describe BookingDocument, type: :model do
  subject(:document) { ExplicitDocument.new }

  describe "associations" do
    it { is_expected.to have_many(:document_references) }
  end
end
