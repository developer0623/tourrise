# frozen_string_literal: true

class Cancellation < ApplicationRecord
  belongs_to :cancellable, polymorphic: true
  belongs_to :cancellation_reason
  belongs_to :user
end
