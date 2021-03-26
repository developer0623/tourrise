# frozen_string_literal: true

module Easybill
  class Engine < ::Rails::Engine
    isolate_namespace Easybill

    config.generators do |g|
      g.test_framework :rspec
    end

    config.active_job.return_false_on_aborted_enqueue = true
  end
end
