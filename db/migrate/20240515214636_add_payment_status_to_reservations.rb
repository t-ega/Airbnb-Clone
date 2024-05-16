class AddPaymentStatusToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :payment_status, :string
    add_column :reservations, :wallet_address, :string
  end
end
