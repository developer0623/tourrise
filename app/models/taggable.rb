# frozen_string_literal: true

class Taggable < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag
end
