# frozen_string_literal: true

module Referenceable
  extend ActiveSupport::Concern

  included do
    has_many :document_references, as: :item
    has_many :invoices, through: :document_references, source: :document, source_type: "BookingInvoice"
    has_many :offers, through: :document_references, source: :document, source_type: "BookingOffer"

    scope :invoiced, lambda {
      joins(:document_references).where(document_references: { document_type: "BookingInvoice" })
    }

    scope :offered, lambda {
      joins(:document_references).where(document_references: { document_type: "BookingOffer" })
    }

    scope :not_referenced, lambda {
      left_joins(:document_references).where(document_references: { id: nil })
    }

    scope :by_event_and_document, lambda { |document, event|
      PaperTrail::Version.referenced_by_document_and_event(document, event).reify_versions
    }

    scope :by_document, lambda { |document|
      PaperTrail::Version.referenced_by_document(document).reify_versions
    }

    scope :created_by_document, ->(document) { by_event_and_document(document, :added) }
    scope :updated_by_document, ->(document) { by_event_and_document(document, :modified) }
    scope :removed_by_document, ->(document) { by_event_and_document(document, :canceled) }
  end

  def invoice
    invoices.first
  end

  def invoiced?
    invoices.any?
  end

  def offered?
    offers.any?
  end
end
