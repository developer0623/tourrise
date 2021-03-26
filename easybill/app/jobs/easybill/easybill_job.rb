# frozen_string_literal: true

module Easybill
  class EasybillJob < ApplicationJob
    queue_as :default

    before_enqueue do |_job|
      throw(:abort) unless ENV["EASYBILL_API_KEY"].present?
    end
  end
end
