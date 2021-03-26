# frozen_string_literal: true

class Tag < ApplicationRecord
  extend ActiveModel::Naming

  has_many :taggables

  belongs_to :tag_group, optional: true

  translates :name

  validates :name, :handle, presence: true

  validates :handle, uniqueness: { case_sensitive: false }
  validates :handle, format: { with: /\A[a-z|-|+|_]+\z/ }
end
