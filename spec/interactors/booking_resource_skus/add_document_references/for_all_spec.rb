require 'rails_helper'

RSpec.describe BookingResourceSkus::AddDocumentReferences::ForAll, type: :interactor do
  subject { described_class.organized }

  let(:expected_organized_classes) do
    [
      BookingResourceSkus::AddDocumentReferences::ForCreated,
      BookingResourceSkus::AddDocumentReferences::ForUpdated,
      BookingResourceSkus::AddDocumentReferences::ForCanceled
    ]
  end

  it { is_expected.to eq(expected_organized_classes) }
end
