# frozen_string_literal: true

module Easybill
  class Employee < ApplicationRecord
    belongs_to :user

    validates :user, presence: true
    validates :user, uniqueness: true
  end
end
