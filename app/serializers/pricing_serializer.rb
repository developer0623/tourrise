# frozen_string_literal: true

class PricingSerializer < JSONAPI::Serializable::Resource
  type :pricing

  attributes :id,
             :price_cents,
             :price_currency,
             :time_base,
             :time_rate,
             :person_rate

  def time_base
    object.time_base.to_h
  end
end
