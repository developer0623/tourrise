# frozen_string_literal: true

module BookingResourceSkus
  module Time
    extend ActiveSupport::Concern

    included do
      def with_date_and_time_range?
        with_date_range? && with_time_range?
      end

      def with_date_range?
        booking_attribute_values.map(&:handle).include?("starts_on") && booking_attribute_values.map(&:handle).include?("ends_on")
      end

      def with_time_range?
        booking_attribute_values.map(&:handle).include?("start_time") && booking_attribute_values.map(&:handle).include?("end_time")
      end

      def start_time
        return unless with_time_range?

        booking_attribute_values.find { |booking_attribute_value| booking_attribute_value.handle.to_sym == :start_time }&.value
      end

      def end_time
        return unless with_time_range?

        booking_attribute_values.find { |booking_attribute_value| booking_attribute_value.handle.to_sym == :end_time }&.value
      end

      def starts_on
        starts_on_attribute_value = booking_attribute_values.find { |booking_attribute_value| booking_attribute_value.handle.to_sym == :starts_on }
        return unless starts_on_attribute_value.present?

        starts_on_attribute_value.value
      end

      def ends_on
        ends_on_attribute_value = booking_attribute_values.find { |booking_attribute_value| booking_attribute_value.handle.to_sym == :ends_on }
        return unless ends_on_attribute_value.present?

        ends_on_attribute_value.value
      end
    end
  end
end
