class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.integer :guest_id, null: false
      t.integer :property_id, null: false
      t.datetime :checkin_date, null: false
      t.datetime :checkout_date, null: false
      t.integer :total, null: false

      t.timestamps
    end
  end
end
