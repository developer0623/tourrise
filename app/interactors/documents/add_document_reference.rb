# frozen_string_literal: true

module Documents
  class AddDocumentReference
    include Interactor

    delegate :item, :document, :event, :price, to: :context

    def call
      document.document_references.new(
        item: item,
        item_version_id: item_version_id,
        event: event,
        price: price
      )
    end

    private

    def item_version_id
      return unless item.respond_to?(:versions)
      return unless item.versions.last.present?

      item.versions.last.id
    end
  end
end
