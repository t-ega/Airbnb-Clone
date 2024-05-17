class AddEstimatedCryptoAmountToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :estimated_crypto_amount, :decimal
  end
end
