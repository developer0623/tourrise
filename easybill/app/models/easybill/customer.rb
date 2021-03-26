# frozen_string_literal: true

module Easybill
  class Customer < ApplicationRecord
    belongs_to :customer

    validates :external_id, presence: true
  end
end
