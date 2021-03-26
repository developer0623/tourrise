# frozen_string_literal: true

class BookingResourceSkuValidator
  include ActiveModel::Validations

  attr_accessor :booking_resource_sku

  validates :assigned_participants_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: :min_occupancy,
    less_than_or_equal_to: :max_occupancy
  }, if: :with_availability?

  validates :assigned_adults_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: :min_adults,
    less_than_or_equal_to: :max_adults
  }, if: :occupation_configuration

  validates :assigned_kids_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: :min_kids,
    less_than_or_equal_to: :max_kids
  }, if: :occupation_configuration

  validates :assigned_babies_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: :min_babies,
    less_than_or_equal_to: :max_babies
  }, if: :occupation_configuration

  def initialize(booking_resource_sku)
    @booking_resource_sku = booking_resource_sku
  end

  private

  def with_availability?
    booking_resource_sku.availability.present?
  end

  def occupation_configuration
    return @occupation_configuration if defined?(@occupation_configuration)

    occupation_configuration_snapshot = @booking_resource_sku.resource_sku_snapshot["occupation_configuration"]

    return if occupation_configuration_snapshot.blank?

    @occupation_configuration = OccupationConfiguration.new(occupation_configuration_snapshot)
  end

  def min_occupancy
    return 1 if occupation_configuration.blank?

    occupation_configuration.min_occupancy
  end

  def max_occupancy
    return Float::INFINITY if occupation_configuration.blank?

    occupation_configuration.max_occupancy
  end

  def min_adults
    occupation_configuration.min_adults
  end

  def max_adults
    occupation_configuration.max_adults
  end

  def min_kids
    occupation_configuration.min_kids
  end

  def max_kids
    occupation_configuration.max_kids
  end

  def min_babies
    occupation_configuration.min_babies
  end

  def max_babies
    occupation_configuration.max_babies
  end

  def assigned_participants_count
    booking_resource_sku.participants.count
  end

  def assigned_adults_count
    booking_resource_sku.participants.adults.count
  end

  def assigned_kids_count
    booking_resource_sku.participants.kids.count
  end

  def assigned_babies_count
    booking_resource_sku.participants.babies.count
  end
end
