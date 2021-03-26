# frozen_string_literal: true

class DocumentReference < ApplicationRecord
  enum event: { added: 0, modified: 1, canceled: 2 }

  monetize :price_cents

  belongs_to :document, polymorphic: true
  belongs_to :item, -> { with_deleted }, polymorphic: true

  validates :item_version_id, presence: true
end
