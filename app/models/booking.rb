# frozen_string_literal: true

class Booking < ApplicationRecord
  has_paper_trail ignore: %i[created_at updated_at]

  SECONDARY_STATES = %w[offer_missing offer_sent offer_rejected invoice_missing invoice_sent].freeze

  include AASM

  aasm do
    state :draft, initial: true
    state :requested
    state :in_progress
    state :booked
    state :canceled
    state :closed

    event :request do
      transitions from: :draft, to: :requested
    end

    event :process do
      transitions from: :requested, to: :in_progress
    end

    event :release do
      transitions from: :in_progress, to: :requested
    end

    event :commit do
      transitions from: :in_progress, to: :booked
    end

    event :close do
      transitions from: %i[requested in_progress], to: :closed
    end

    event :cancel do
      after do
        update_attribute(:canceled_at, Time.zone.now)
      end

      transitions from: :booked, to: :canceled
    end

    event :reopen do
      transitions from: :booked, to: :in_progress, guard: :assigned?
      transitions from: :closed, to: :in_progress, guard: :assigned?
      transitions from: :closed, to: :requested
    end
  end

  belongs_to :creator, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :duplicate_of, class_name: "Booking", optional: true
  belongs_to :product_sku
  belongs_to :season, optional: true

  belongs_to :customer, optional: true
  accepts_nested_attributes_for :customer

  has_many :taggables, as: :taggable
  has_many :tags, through: :taggables

  has_many :booking_room_assignments, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :booking_room_assignments, allow_destroy: true

  has_many :booking_flight_requests, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :booking_flight_requests, reject_if: :all_blank, allow_destroy: true

  has_many :booking_rentalbike_requests, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :booking_rentalbike_requests, reject_if: :all_blank, allow_destroy: true

  has_many :booking_rentalcar_requests, dependent: :destroy, index_errors: true
  accepts_nested_attributes_for :booking_rentalcar_requests, reject_if: :all_blank, allow_destroy: true

  has_many :booking_participants, dependent: :destroy
  has_many :participants, through: :booking_participants
  accepts_nested_attributes_for :participants, reject_if: :all_blank, allow_destroy: true

  has_many :booking_resource_skus, dependent: :destroy, index_errors: true, autosave: true
  accepts_nested_attributes_for :booking_resource_skus,
                                reject_if: proc { |attributes| attributes["quantity"].to_i.zero? || attributes["resource_sku_id"].blank? },
                                allow_destroy: true

  has_many :flights, through: :booking_resource_skus

  has_many :booking_resource_sku_groups

  has_many :resource_skus, through: :booking_resource_skus
  has_many :booking_offers, dependent: :destroy
  has_many :booking_invoices, dependent: :destroy
  has_many :booking_credits, dependent: :destroy

  has_one :product, through: :product_sku

  has_rich_text :wishyouwhat

  validates :creator,
            :product_sku,
            :customer,
            :scrambled_id,
            :title,
            presence: true, unless: -> { draft? }
  validates_with EndsOnAfterStartsOnValidator
  validates :secondary_state, inclusion: { in: SECONDARY_STATES }, allow_blank: true

  scope :assigned, -> { where.not(assignee_id: nil) }
  scope :unassigned, -> { where(assignee_id: nil) }
  scope :without_drafts, -> { where.not(aasm_state: :draft) }
  scope :with_state, lambda { |status|
    case status
    when "initial"
      unassigned
    when "in_progress"
      assigned
    else
      all
    end
  }
  scope :for_product_id, lambda { |product_id|
    product_sku_ids = ProductSku.where(product_id: product_id).pluck(:id)

    where(product_sku_id: product_sku_ids)
  }
  scope :overdue, -> { where.not(due_on: nil).where(arel_table[:due_on].lt(Time.zone.now)) }
  scope :for_assignee_id, ->(assignee_id) { where(assignee_id: assignee_id) }
  scope :with_product_translations, ->(locale) { joins(:product).merge(Product.with_translations(locale)) }
  scope :with_product_sku_translations, ->(locale) { joins(:product_sku).merge(ProductSku.with_translations(locale)) }

  delegate :first_name, :last_name, :email, to: :customer

  before_validation :generate_scrambled_id
  before_validation :update_participant_counters, unless: -> { draft? }

  def people_count
    adults.to_i + kids.to_i + babies.to_i
  end

  def total_price
    billable_booking_resource_sku_prices = booking_resource_skus.visible_to_customer.sum(&:total_price)
    billable_booking_resource_sku_group_prices = booking_resource_sku_groups.sum(&:price)

    billable_booking_resource_sku_group_prices + billable_booking_resource_sku_prices
  end

  def assigned?
    assignee.present?
  end

  def unassigned?
    !assigned?
  end

  def with_date_range?
    starts_on.present? && ends_on.present?
  end

  def nights
    return 1 if ends_on.blank? || starts_on.blank?

    (ends_on - starts_on).to_i
  end

  # TODO: this should move out of this model.
  def update_participant_counters
    groups = participants.reject(&:marked_for_destruction?).group_by(&:participant_type)
    Customer.participant_types.keys.each do |participant_type|
      group_count = groups[participant_type]&.count.to_i
      write_attribute(participant_type.to_s.pluralize, group_count)
    end
  end

  private

  def generate_scrambled_id
    return if scrambled_id.present?

    scrambled_id = ScrambledId.generate

    scrambled_id = ScrambledId.generate while self.class.find_by(scrambled_id: scrambled_id).present?

    self.scrambled_id = scrambled_id
  end
end
