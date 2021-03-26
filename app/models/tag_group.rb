# frozen_string_literal: true

class TagGroup < ApplicationRecord
  has_many :tags

  validates :name, presence: true
end
