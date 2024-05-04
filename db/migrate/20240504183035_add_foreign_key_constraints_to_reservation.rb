class AddForeignKeyConstraintsToReservation < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :reservations, :properties, column: :property_id
    add_foreign_key :reservations, :users, column: :guest_id
  end
end
