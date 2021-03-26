# frozen_string_literal: true

class CancellationReason < ApplicationRecord
  acts_as_paranoid

  has_many :cancellations

  validates :name, presence: true

  validates :name, uniqueness: { case_sensitive: false }
end
