class AddAasmStateToBookings < ActiveRecord::Migration[5.2]
  class Booking < ApplicationRecord
    include AASM

    belongs_to :assignee, class_name: 'User', optional: true

    aasm do
      state :requested, initial: true
      state :in_progress
      state :booked
      state :canceled
      state :closed

      event :process do
        transitions from: :requested, to: :in_progress
      end
    end
  end

  def up
    add_column :bookings, :aasm_state, :string

    Booking.all.each do |booking|
      booking.assignee.present? ? booking.process : booking.aasm_state = Booking.aasm.initial_state
      booking.save!
    end
  end

  def down
    remove_column :bookings, :aasm_state, :string
  end
end

