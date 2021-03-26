# frozen_string_literal: true

module Pricings
  module ConsecutiveDays
    class SelectRange
      include Interactor

      delegate :ranges, :days, to: :context

      before do
        context.errors ||= []
      end

      def call
        context.range = range
      end

      private

      def range
        @range ||= ranges.find { |range| days_fit_range?(range) }
      end

      def days_fit_range?(range)
        days.between?(range.from, range.to)
      end
    end
  end
end
