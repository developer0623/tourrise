# frozen_string_literal: true

class BookingDocumentDecorator < Draper::Decorator
  delegate_all

  decorates_association :booking
  decorates_association :payments

  def details_attributes
    [
      [:title, title],
      [:number, number],
      [:creator, creator],
      [:total_price, human_total_price],
      [:published, object.scrambled_id],
      [:created_at, h.l(created_at, format: :long)]
    ]
  end

  def human_total_price
    h.humanized_money_with_symbol(object.total_price)
  end

  def title
    h.t("booking_form.#{object.class.name.underscore}.headline", name: booking_snapshot["title"])
  end

  def creator
    object.versions.first&.whodunnit
  end

  def human_model_name
    object.class.model_name.human
  end

  def number
    return "#" unless easybill_document.present?

    easybill_document.external_number
  end

  def frontoffice_link
    return unless object.published?

    h.link_to(frontoffice_link_label, h.public_send(frontoffice_path_method, object.booking.scrambled_id, object.scrambled_id), target: "_blank")
  end

  def details_link
    h.link_to(h.t("show"), h.public_send("#{object.class.name.underscore}_path", object.id))
  end

  def customer_link
    return unless external_document_preview_url.present?

    h.link_to(customer_link_label, external_document_preview_url, target: "_blank")
  end

  def publish_link
    h.link_to(
      frontoffice_publish_link_label,
      h.public_send(publish_document_path, object.booking, object),
      method: "patch"
    )
  end

  def unpublish_link
    h.link_to(
      frontoffice_unpublish_link_label,
      h.public_send(unpublish_document_path, object.booking, object),
      method: "patch"
    )
  end

  def accepted?; end

  def rejected?; end

  private

  def frontoffice_link_label
    h.t("booking_documents.frontoffice_link_label")
  end

  def customer_link_label
    h.t("booking_documents.customer_link_label")
  end

  def frontoffice_path_method
    "frontoffice_#{object.class.name.underscore}_path"
  end

  def frontoffice_publish_link_label
    h.t("booking_documents.frontoffice_publish_link_label")
  end

  def publish_document_path
    "publish_booking_#{object.class.name.underscore}_path"
  end

  def frontoffice_unpublish_link_label
    h.t("booking_documents.frontoffice_unpublish_link_label")
  end

  def unpublish_document_path
    "unpublish_booking_#{object.class.name.underscore}_path"
  end

  def external_document_preview_url
    return unless FrontofficeSetting.any?
    return unless FrontofficeSetting.first.external_document_preview_url.present?

    FrontofficeSetting.first.external_document_preview_url
                      .gsub("{{document_id}}", object.scrambled_id)
                      .gsub("{{booking_id}}", object.booking.scrambled_id)
                      .gsub("{{document_type}}", object.class.name.remove("Booking").downcase.pluralize)
  end
end
