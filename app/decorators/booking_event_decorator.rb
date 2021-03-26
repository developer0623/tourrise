# frozen_string_literal: true

class BookingEventDecorator < Draper::Decorator
  delegate_all

  def description
    case object.event
    when "create"
      I18n.t("booking_events.description.record_created")
    when "update"
      object.changeset.map do |k, v|
        attribute = I18n.t("activerecord.attributes.#{object.item_type.underscore}.#{k}")
        attribute_type = object.item_type.constantize.columns_hash[k.to_s].type
        from_value = attribute_value(v.first, attribute_type)
        to_value = attribute_value(v.last, attribute_type)
        I18n.t("booking_events.description.record_updated", attribute: attribute, from: from_value, to: to_value)
      end.join(", ")
    when "destroy"
      I18n.t("booking_events.description.record_deleted")
    end
  end

  def event_date
    I18n.l(object.created_at, format: :long)
  end

  def self.collection_decorator_class
    BookingEventsDecorator
  end

  def event_type
    I18n.t("booking_events.event_type.#{object.event}")
  end

  def item_name
    I18n.t("activerecord.models.#{object.item_type.underscore}.one")
  end

  private

  def attribute_value(value, type)
    return "nil" if value.nil?

    %i[datetime date].include?(type) ? I18n.l(value, format: :long) : value
  end
end
