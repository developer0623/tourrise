class AddSlugToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :scrambled_id, :string, null: false, index: true

    Booking.all.each do |booking|
      scrambled_id = ScrambledId.generate

      while Booking.find_by(scrambled_id: scrambled_id).present?
        scrambled_id = ScrambledId.generate
      end

      booking.update(scrambled_id: scrambled_id)
    end
  end
end
