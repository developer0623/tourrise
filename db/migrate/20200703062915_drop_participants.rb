class DropParticipants < ActiveRecord::Migration[6.0]
  class Customer < ApplicationRecord
    has_many :bookings
    has_many :booking_customers
    has_many :participate_bookings, through: :booking_customers, source: :booking
    has_many :booking_resource_sku_customers, dependent: :destroy
    has_many :booking_resource_skus, through: :booking_resource_sku_customers
    enum participant_type: %i[adult kid baby]

  end

  class Participant < ApplicationRecord
    belongs_to :booking
    belongs_to :customer, optional: true
    belongs_to :participant_type, optional: true
    has_many :booking_resource_sku_participants
    has_many :booking_resource_skus, through: :booking_resource_sku_participants
  end

  def up
    Participant.all.preload(:participant_type, :booking).find_each do |participant|
      attrs = participant.attributes.slice("first_name", "last_name", "birthdate", "email", "placeholder")
      attrs[:participant_type] = participant.participant_type.handle.singularize
      customer = Customer.new(attrs)

      p customer.errors.full_messages unless customer.save
      if customer.persisted?
        customer.participate_bookings << participant.booking
        customer.booking_resource_skus << participant.booking_resource_skus
      end
    end

    drop_table :participants
  end

  def down
    create_table :participants do |t|
      t.references :booking
      t.references :customer
      t.string :first_name
      t.string :last_name
      t.date :birthdate
      t.string :email
      t.references :participant_type
      t.boolean :placeholder, default: false
    end

    create_table :booking_resource_sku_participants do |t|
      t.belongs_to :booking_resource_sku
      t.belongs_to :participant
    end

    participant_types = {
      adult: ParticipantType.adults,
      kid: ParticipantType.kids,
      baby: ParticipantType.babies
    }

    Customer.joins(:participate_bookings).select("customers.*, booking_customers.booking_id").find_each do |customer|
      attrs = customer.attributes.slice("first_name", "last_name", "birthdate", "email", "placeholder", "booking_id")
      attrs[:participant_type] = participant_types[customer.participant_type.to_sym]
      participant = Participant.new(attrs)

      p participant.errors.full_messages unless participant.save

      if participant.persisted?
        participant.booking_resource_skus << customer.booking_resource_skus
      end
    end
  end
end
