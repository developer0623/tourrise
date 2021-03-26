# frozen_string_literal: true

module Easybill
  class Offer < ApplicationRecord
    belongs_to :booking_offer

    validates :external_id, presence: true
  end
end
