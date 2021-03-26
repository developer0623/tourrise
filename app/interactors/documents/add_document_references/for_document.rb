# frozen_string_literal: true

module Documents
  module AddDocumentReferences
    class ForDocument
      include Interactor::Organizer

      delegate :document, to: :context

      before do
        context.fail!(message: I18n.t("interactor_errors.empty", attribute: :document)) unless document.present?
      end

      organize BookingResourceSkus::AddDocumentReferences::ForAll,
               BookingResourceSkuGroups::AddDocumentReferences::ForAll,
               BookingCredits::AddDocumentReferences::ForAll
    end
  end
end
