# frozen_string_literal: true

module Easybill
  class CustomerSync < ApplicationRecord
    scope :last_sync_at, -> { pluck(:last_sync_at).max }
  end
end
