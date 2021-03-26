# frozen_string_literal: true

module PaperTrail
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern

    scope :referenced_by_document, lambda { |document|
      joins("JOIN document_references ON document_references.item_version_id = versions.id")
        .where(document_references: { document_type: document.class.name, document_id: document.id })
    }

    scope :referenced_by_document_and_event, lambda { |document, event|
      referenced_by_document(document).where(document_references: { event: DocumentReference.events[event.to_s] })
    }

    def self.reify_versions
      all.map { |version| _reify(version) }
    end

    def reify_version
      self.class._reify(self)
    end

    def self._reify(version)
      version.next ? version.next.reify : (version.item || version.reify)
    end
  end
end
