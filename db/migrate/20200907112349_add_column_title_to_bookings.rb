class AddColumnTitleToBookings < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookings, :title, :string
    remove_column :bookings, :first_name, :string
    remove_column :bookings, :last_name, :string
    remove_column :bookings, :address_line_1, :string
    remove_column :bookings, :address_line_2, :string
    remove_column :bookings, :zip, :string
    remove_column :bookings, :city, :string
    remove_column :bookings, :state, :string
    remove_column :bookings, :country, :string
    remove_column :bookings, :company, :string
    remove_column :bookings, :email, :string
    remove_column :bookings, :phone, :string
    remove_column :bookings, :gender, :string
    remove_column :bookings, :birthdate, :date

    add_column :bookings, :title, :string
  end
end
