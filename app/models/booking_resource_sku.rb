# frozen_string_literal: true

class BookingResourceSku < ApplicationRecord
  include Referenceable
  include Cancellable
  include BookingResourceSkus::Time

  acts_as_paranoid

  has_paper_trail ignore: %i[created_at updated_at]

  monetize :price_cents

  serialize :resource_sku_snapshot, JSON
  serialize :resource_snapshot, JSON

  belongs_to :booking, touch: true
  belongs_to :resource_sku, optional: true
  belongs_to :financial_account, optional: true
  belongs_to :cost_center, optional: true

  has_one :booking_resource_sku_availability
  accepts_nested_attributes_for :booking_resource_sku_availability, allow_destroy: true

  has_one :availability, through: :booking_resource_sku_availability

  has_many :booking_attribute_values, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :booking_attribute_values, allow_destroy: true

  has_many :booking_attributes, through: :booking_attribute_values

  has_many :booking_resource_sku_flights, dependent: :destroy
  has_many :flights, through: :booking_resource_sku_flights
  accepts_nested_attributes_for :flights, allow_destroy: true

  has_and_belongs_to_many :booking_resource_sku_groups

  has_many :booking_resource_sku_customers, dependent: :destroy
  has_many :participants, through: :booking_resource_sku_customers, source: :customer

  validates :quantity, :price, :resource_snapshot, :resource_sku_snapshot, presence: true
  validate :booking_attribute_values
  validate :cached_date_range_values

  validates_associated :booking_resource_sku_availability
  validates_associated :booking_attribute_values

  delegate :aasm_state, to: :booking

  scope :visible_to_customer, -> { where(internal: false) }

  scope :with_aasm_state, lambda { |state|
    includes(:booking).where(bookings: { aasm_state: state })
  }

  scope :availability_reducing, lambda {
    left_joins(:booking_resource_sku_availability).where.not(booking_resource_sku_availabilities: { blocked_at: nil }).or(
      left_joins(:booking_resource_sku_availability).where.not(booking_resource_sku_availabilities: { booked_at: nil })
    )
  }

  scope :without_drafts, -> { with_aasm_state(%i[requested in_progress booked canceled closed]) }

  scope :with_resource_type_id, lambda { |resource_type_id|
    includes(resource_sku: :resource).where(resources: { resource_type_id: resource_type_id })
  }

  scope :in_date_range, lambda { |starts_on, ends_on|
    starts_on_query = arel_table[:starts_on].lteq(ends_on)
    ends_on_query = arel_table[:ends_on].gteq(starts_on)

    where(starts_on_query.and(ends_on_query))
  }

  scope :not_grouped, lambda {
    left_joins(:booking_resource_sku_groups).where(booking_resource_sku_groups: { id: nil })
  }

  scope :groupable, -> { not_grouped.not_cancelled.not_referenced }

  scope :without_ids, ->(ids) { where.not(id: ids) }

  before_validation :memoize_resource_sku_details
  before_validation :memoize_financial_information
  before_validation :memoize_date_range
  before_validation :mark_booking_resource_sku_availability_for_destruction

  def total_price
    quantity * price
  end

  def cost_center
    super || booking.product_sku.cost_center
  end

  def financial_account
    super || booking.product_sku.financial_account
  end

  def with_occupation_configuration?
    if persisted?
      resource_sku_snapshot["occupation_configuration_id"].present?
    else
      resource_sku.occupation_configuration.present?
    end
  end

  def required_quantity
    if with_occupation_configuration?
      1
    else
      participants.map.count
    end
  end

  def vat
    resource_sku_snapshot["vat"]
  end

  def resource_type
    if persisted?
      ResourceType.find(resource_snapshot["resource_type_id"])
    else
      resource_sku&.resource_type
    end
  end

  def serialize_for_snapshot
    to_include = %i[booking_attribute_values participants flights]
    methods = %i[cost_center financial_account]

    serializable_hash(include: to_include, methods: methods).slice(*BookingResourceSkuSerializer::KEYS)
  end

  def grouped?
    booking_resource_sku_groups.any?
  end

  private

  def memoize_resource_sku_details
    self.resource_sku_snapshot = resource_sku.serializable_hash(include: :occupation_configuration) unless resource_sku_snapshot.present?
    self.resource_snapshot = resource_sku.resource unless resource_snapshot.present?
  end

  def memoize_financial_information
    self.financial_account = booking.product_sku.financial_account unless read_attribute(:financial_account_id).present?
    self.cost_center = booking.product_sku.cost_center unless read_attribute(:cost_center_id).present?
  end

  def memoize_date_range
    return unless with_date_range?

    self.starts_on = booking_attribute_values.find { |value| value.handle == "starts_on" }.value
    self.ends_on = booking_attribute_values.find { |value| value.handle == "ends_on" }.value
  end

  def cached_date_range_values
    return unless with_date_range?

    errors.add(:starts_on, :missing) unless starts_on.present?
    errors.add(:ends_on, :missing) unless ends_on.present?
  end

  def mark_booking_resource_sku_availability_for_destruction
    return unless booking_resource_sku_availability.present?

    booking_resource_sku_availability.mark_for_destruction if booking_resource_sku_availability.availability_id.blank?
  end
end
