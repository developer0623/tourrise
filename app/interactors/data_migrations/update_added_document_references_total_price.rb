# frozen_string_literal: true

module DataMigrations
  class UpdateAddedDocumentReferencesTotalPrice
    include Interactor

    def call
      DocumentReference.added.where(item_type: "BookingResourceSku").where(price_cents: 0).find_each do |document_reference|
        document_reference.update!(
          price: calculated_price(document_reference)
        )
      end
    end

    private

    def calculated_price(document_reference)
      version = document_reference.item.versions.find(document_reference.item_version_id)

      version.reify_version.total_price
    end
  end
end
